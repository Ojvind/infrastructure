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
}

resource "google_project_service" "this" {
  for_each = toset([
    "compute",
    "container",
    "pubsub"
  ])

  service = "${each.key}.googleapis.com"

  project            = google_project.this.project_id
  disable_on_destroy = false
}
