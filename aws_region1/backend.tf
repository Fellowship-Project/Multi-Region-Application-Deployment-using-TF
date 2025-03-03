terraform {
   backend "s3" {
      bucket         = "prod-tfstate-region-1" # change this
      key            = "deepak/terraform.tfstate"
      region         = "ap-south-1"
      encrypt        = true
      dynamodb_table = "terraform-lock-region-1"  # Enables locking
   }
}
