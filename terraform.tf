terraform {
  backend "s3" {
    bucket = "terraform-demo-reorganizing-repos"
    key    = "unified-again-repo-3"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}