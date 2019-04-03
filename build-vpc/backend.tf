terraform {
  backend "s3" {
    key            = "vpc-build/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
