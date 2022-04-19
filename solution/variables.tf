variable "aws_access_key_id" {
  type = string
  default = ""
}

variable "aws_secret_access_key" {
  type = string
  default = ""
}

variable "aws_region" {
  type = string
  default = ""
}

variable "docker_host" {
  type = string
  default = "unix:///var/run/docker.sock"
}
