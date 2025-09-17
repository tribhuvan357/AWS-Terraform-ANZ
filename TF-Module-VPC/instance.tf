module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"

  for_each = toset(["one", "two", "three"])

  name = "Module-instance-${each.key}"

  ami           = "ami-0b982602dbb32c5bd"
  instance_type = "t3.micro"
  monitoring    = false
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name        = "EC2-Module"
    Terraform   = "true"
    Environment = "dev"
  }
}
