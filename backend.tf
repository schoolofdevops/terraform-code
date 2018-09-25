terraform {
  backend "s3" {
    bucket         = "devopsdemo-tf-backend"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devops-demo-table"
  }
}
