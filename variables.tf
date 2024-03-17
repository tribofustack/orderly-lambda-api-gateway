variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "bucket_name" {
  type = string
  default = "my-functions-source-bucket"
}

variable "consumer" {
  type = string
  default = "orderly"
}

variable "auth_url" {
  type = string
}

