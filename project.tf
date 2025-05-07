variable "project_id" {}
variable "project_name" {}
variable "organization_id" {}
variable "billing_account" {}
variable "region" {}

provider "google" {
  region  = var.region
  project = var.project_id
}

resource "google_project" "this" {
  project_id      = var.project_id
  name            = var.project_name
  org_id          = var.organization_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
  lifecycle {
    prevent_destroy = false  # Tillåter borttagning av projekt
  }
}

resource "google_project_service" "this" {
  for_each = toset([
    "compute",
    "logging",
    "monitoring",
    # "container",
    # "pubsub",
    # "iam",
    # "cloudkms",
    # "iamcredentials",
    # "cloudresourcemanager",
    # "sts",
    # "cloudfunctions",
    # "eventarc",
    # "run",
    # "cloudbuild",
    # "storage"
  ])

  service = "${each.key}.googleapis.com"

  project            = google_project.this.project_id
  disable_on_destroy = false
}