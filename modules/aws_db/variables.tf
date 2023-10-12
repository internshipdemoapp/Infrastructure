
variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "secret_name" {
    type = string
    default = "AppleStore/Db"
}