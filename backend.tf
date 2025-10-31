terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-for-project"
    key            = "secure-webapp/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}