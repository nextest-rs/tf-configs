terraform {
  backend "s3" {
    bucket = "nextest-tf-state"
    key    = "tf-configs/terraform.tfstate"
    region = "auto"

    endpoints = {
      s3 = "https://eeaeed53a084df655bd2200e77bbc077.r2.cloudflarestorage.com"
    }

    use_path_style              = true
    use_lockfile                = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}
