terraform {
    required_version = ">=1.2.4,<1.3"
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = ">=4.22.0,<4.23"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region = var.region
  default_tags {
    tags = {
      system_name = var.system_name
      environment = var.environment_name
      team = "chirag_data_team"
    }
  }
}