resource "google_storage_bucket" "bucket" {
  name     = "my-functions-source-bucket-${var.project_id}"
  location = var.region
}