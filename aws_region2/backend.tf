terraform {
   backend "s3" {
    bucket         = "prod-tfstate-region2" # change this
    key            = "deepak/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
}
 }