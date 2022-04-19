terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    docker = { 
      source = "kreuzwerker/docker"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region = var.aws_region
}

provider "docker" {
  host = var.docker_host
  registry_auth {
    address = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_ecr_repository" "repository" {
  name = "foo"
}

resource "docker_registry_image" "image" {
  name = "${aws_ecr_repository.repository.repository_url}:latest" # provide full ecr image address
  build {
    context = "./" # Directory with docker context
    dockerfile = "Dockerfile" # Path to dockerfile
  }
}

resource "aws_lambda_function" "function" {
  function_name = ""
  role = aws_iam_role.foo.arn
  package_type = "Image"
  image_uri = "${aws_ecr_repository.repository.repository_url}:latest"
  depends_on = [
    docker_registry_image.image # dependent on docker image build
  ]
}
