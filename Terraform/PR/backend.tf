terraform {
  backend "gcs" {
    bucket = "sbezanovic_bucket_pr"
    prefix = "terraform/state"
  }
}

