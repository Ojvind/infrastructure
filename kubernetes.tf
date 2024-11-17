# resource "google_container_cluster" "prima_cluster" {
#   project  = google_project.this.project_id
#   name     = "prima-cluster"
#   location = "europe-north1-a"

#   initial_node_count       = 1
#   deletion_protection      = false
# }