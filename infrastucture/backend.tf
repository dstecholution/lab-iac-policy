resource "google_storage_bucket" "backend-bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true
  versioning {
    enabled = true
  }
}
