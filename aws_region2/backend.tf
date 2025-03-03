terraform {
   backend "s3" {
      bucket         = "prod-tfstate-region-2" # change this
      key            = "deepak/terraform.tfstate"
      region         = "ap-southeast-1"
      encrypt        = true
      dynamodb_table = "terraform-lock-region-2"  # Enables locking
   }
}
