terraform {
  required_version = ">= 1.11.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }

  backend "s3" {
    region = "cn-northwest-1"
    bucket = "{{BACKEND_BUCKET}}"
    key    = "{{STATE_KEY}}"
  }
}
