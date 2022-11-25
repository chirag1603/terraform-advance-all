variable "aws_profile" {
    type = string
    description = "The name of the AWS profile to use. The profile must be configured in the AWS settings."
    default = "default"
}
variable "region" {
  default = "us-east-1"
}

variable "account_id"{
    type = string
    description = "AWS account to deploy the resources"
}
variable "system_name" {
    type = string
    default = "chirag-ds-dropbox"
    description = "Prefix which will be prefix to the name of all resources and included in tags."
}

variable "environment_name" {
    type = string
    description = "suffix which will be append to the name of all resources and included in tags."
    default = "prod"  
}

variable "lifecycle_rules" {
  type = list
  default = []
}

variable "expiration" {
    type = number
    description = "the number of days in which the object will expire "
    default = 30
}

variable "product_names"{
    type = list(string)
    description = "The list of Products Using the Dropbox"
}

/* variable "product_lifecycle"{
    description = "lifecycle block for_each product"
    type = map(string)
    default = {}
} */