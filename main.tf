terraform {
  required_version = ">= 0.13"
  required_providers {
    google = ">= 5.17.0"
  }
  backend "gcs" {}
}
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region

  depends_on = [ google_project_service.cloudfunctions, google_project_service.storage, google_project_service.cloudbuild ]
}

module "serverless" {
  source      = "./modules/serverless"
  project_id  = var.project_id
  region      = var.region
  consumer    = var.consumer
  auth_url    = var.auth_url
  bucket_name = module.storage.bucket_name

  depends_on = [ module.storage ]
}
