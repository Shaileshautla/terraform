variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "test" # actual key name created in AWS, no .pem extension
}
