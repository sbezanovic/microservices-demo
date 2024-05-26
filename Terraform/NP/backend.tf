terraform {
  backend "gcs" {
    bucket = "sbezanovic_bucket_np"
    prefix = "terraform/state"
  }
}
