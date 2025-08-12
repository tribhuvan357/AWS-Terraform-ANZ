terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.7.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  region = "ap-south-1"
}

resource "random_id" "main" {
  byte_length = 10 # To generate the random numbers which can help in making unique S3 bucket name
  }

resource "aws_s3_bucket" "main" {
  bucket = "tribhuvan357-demo-terraform-${random_id.main.hex}"
}

resource "aws_s3_object" "main" {
    bucket = aws_s3_bucket.main.bucket
    source = "./sample.txt"
    key = "my-cloud-data.txt"
}

output "S3-bucket-name-output" {
  value = random_id.main.hex
}
