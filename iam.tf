# Log Writer & MetricWriter required for Ops Agent
resource "google_project_iam_member" "lovlla_logWriter" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.lovlla.email}"
  project = google_project.this.id
}

resource "google_project_iam_member" "lovlla_metricWriter" {
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.lovlla.email}"
  project = google_project.this.id
}