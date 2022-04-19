# Terraform ECR->Lambda 🐔 & 🥚 Problem

## General 

* Description: Solution to Terraform-AWS Lambda-ECR chicken and egg problem.
* Built With:
  * [Terraform for AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
  * [Terraform for Docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)

## Problem Description

** Defining Lambda Function with ECR Image and ECR image within the same Terraform build path.**

This Lambda Function definition requires the ECR image tagged "latest" within the repository built in same Terraform configuration.

```hcl
resource "aws_ecr_repository" "repository" {
  name = "foo"
}

resource "aws_lambda_function" "foo" {
  function_name = "bar"
  description = "Foo bar"
  role = aws_iam_role.foo.arn
  package_type = "Image"
  image_uri = "${aws_ecr_repository.repository.repository_url}:latest"
}
```

Resulting in error configuring the lambda function as no image has been added to the ecr repository.

## [Solution](solution/main.tf)

Introduce the docker provider to the Terraform Configuration and build docker through Terraform.
