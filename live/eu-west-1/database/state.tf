terraform {
  backend "s3" {
    bucket  = "jp-caillet-firstbucket"
    encrypt = true
    key     = "live/eu-west-1/database/terraform.state"
    region  = "eu-west-1"
  }
}
