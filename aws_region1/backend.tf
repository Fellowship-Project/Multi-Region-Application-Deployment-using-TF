terraform {
   backend "s3" {
    bucket         = "prod-tfstate-region1" # change this
    key            = "deepak/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true

}
 }
