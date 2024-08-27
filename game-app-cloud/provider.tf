terraform {
  required_providers {
    google={
        source = "hashicorp/google"
        version = "5.30.0"
    }
  }
}

provider "google" {
  project = var.project.id
  region = var.project.region
}