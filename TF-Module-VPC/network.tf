provider "aws" {
  region = "ap-south-1"
}

data "aws_availability_zones" "name" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "my-vpc-module"
  cidr = "10.0.0.0/16"

  #azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"] We can either use static value or available data value
  azs             = data.aws_availability_zones.name.names
  private_subnets = ["10.0.0.0/24"]
  public_subnets  = ["10.0.1.0/24"]

  /*enable_nat_gateway = true
  enable_vpn_gateway = true
*/

  tags = {
    Name        = "My-VPC-Module"
    Terraform   = "true"
    Environment = "dev"
  }

}
