terraform {
  backend "s3" {
    bucket = "devs3bucket123"
    key = "terraform/state"  
    region = "ap-south-1"
  }
}
