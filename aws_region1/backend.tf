terraform {
   backend "s3" {
    bucket         = "prod-tfstate-region-1" # change this
    key            = "deepak/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true

}
 }
