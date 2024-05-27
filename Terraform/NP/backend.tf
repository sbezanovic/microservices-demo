terraform {
  backend "gcs" {
    bucket = "sbezanovic_bucket_np_2"
    prefix = "terraform/state"
  }
}

