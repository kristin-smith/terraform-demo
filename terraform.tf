terraform {
  backend "s3" {
    bucket = "terraform-demo-reorganizing-repos"
    key    = "demo-runthrough"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}