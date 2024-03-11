provider "google" {
  project = var.project-id
  region  = var.region
  zone    = var.zone
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "my-functions-source-bucket"
  location = var.region
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
  depends_on = [data.archive_file.function_zip]
}

resource "google_cloudfunctions_function" "default" {
  name                  = "serverless_function"
  description           = "A simple Serverless Function"

  runtime               = "nodejs18"
  available_memory_mb   = 128

  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  trigger_http          = true
  entry_point           = "handler"

  depends_on = [google_storage_bucket_object.function_zip]
}

output "https_trigger_url" {
  value = google_cloudfunctions_function.default.https_trigger_url
}