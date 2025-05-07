# resource "google_compute_network" "this" {
#   project                 = google_project.this.project_id
#   name                    = "gcp-playground-network"
#   auto_create_subnetworks = false
#   routing_mode            = "GLOBAL"
# }

# resource "google_compute_subnetwork" "gcp_playground_europe_north1" {
#   name                     = "gcp-playground-europe-north1"
#   ip_cidr_range            = "10.182.0.0/24"
#   region                   = "europe-north1"
#   network                  = google_compute_network.this.self_link
#   private_ip_google_access = true
# }
