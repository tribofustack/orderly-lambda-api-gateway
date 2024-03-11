data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.root}/src"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function.zip"
  bucket = var.bucket_name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions_function" "default" {
  name                  = "serverless_function"
  description           = "A simple Serverless Function"
  runtime               = "nodejs18"
  available_memory_mb   = 128
  source_archive_bucket = var.bucket_name
  source_archive_object = google_storage_bucket_object.function_zip.name
  trigger_http          = true
  entry_point           = "handler"
  depends_on            = [google_storage_bucket_object.function_zip]
}