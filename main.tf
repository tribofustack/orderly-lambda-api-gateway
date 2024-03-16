provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
}

module "serverless" {
  source      = "./modules/serverless"
  project_id  = var.project_id
  region      = var.region
  consumer    = var.consumer
  auth_url    = var.auth_url
  bucket_name = module.storage.bucket_name
}
