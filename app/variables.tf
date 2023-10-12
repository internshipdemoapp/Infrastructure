variable "region" {
  type    = string
  default = "us-east-1"
}

variable "namespace" {
  type    = string
  default = "dev"
}

variable "service_name" {
  type    = string
  default = "store-web-application"
}

variable "key_pair_name" {
  default = "ssh-key-pair"
}
