# In a real repo this would be:
# terraform {
#   backend "s3" {
#     bucket         = "my-tf-state"
#     key            = "prod/status-page.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
terraform {
  required_version = ">= 1.5"
}
