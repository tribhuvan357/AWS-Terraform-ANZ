terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
    random = {
      source  = "hashicorp/random"
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
  bucket = "mywebapp-demo-bucket-${random_id.main.hex}"
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.main.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.main.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.main.bucket
  source       = "./styles.css"
  key          = "styles.css"
  content_type = "text/css"
}

output "S3-bucket-name" {
  value = aws_s3_bucket.main.id
  #value = random_id.main.hex
}

output "AWS-Static-Website-URL" {
  value = aws_s3_bucket_website_configuration.main.website_endpoint
}
