variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "foundation"
}

variable "owner" {
  type    = string
  default = "TomomasaSekino"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.10.0/24", "10.10.11.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.20.0/24", "10.10.21.0/24"]
}