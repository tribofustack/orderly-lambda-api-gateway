data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.root}"
  output_path = "${path.module}/function.zip"
}

resource "google_project_iam_member" "artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_cloudfunctions_function.default.service_account_email}"
}

resource "google_project_iam_member" "artifact_registry_list" {
  project = var.project_id
  role    = "roles/artifactregistry.list"
  member  = "serviceAccount:${google_cloudfunctions_function.default.service_account_email}"
}

# resource "google_project_iam_custom_role" "artifact_registry_access" {
#   role_id     = "cloudfunctions_artifact_registry_access"
#   title       = "Cloud Functions Artifact Registry Access"
#   description = "Custom role to grant access to Artifact Registry for Cloud Functions"
#   permissions = [
#     "artifactregistry.repositories.reader",
#     "artifactregistry.repositories.list",
#     "artifactregistry.repositories.get",
#     "artifactregistry.packages.download"
#   ]
# }

# resource "google_project_iam_binding" "function_service_account_binding" {
#   project = var.project_id
#   role    = google_project_iam_custom_role.artifact_registry_access.role_id
#   members = [
#     "serviceAccount:${google_cloudfunctions_function.default.service_account_email}"
#   ]
# }

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
  depends_on            = [
    # google_project_iam_binding.function_service_account_binding,
    google_storage_bucket_object.function_zip
  ]

  environment_variables = {
    CONSUMER = var.consumer
    AUTH_URL = var.auth_url
  }
}