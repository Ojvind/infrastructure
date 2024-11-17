# resource "google_compute_instance" "vm_instance" {
#   name         = "terraform-instance"
#   zone         = "europe-north1-a"
#   machine_type = "e2-highmem-2"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network = google_compute_network.this.name
#     subnetwork = google_compute_subnetwork.gcp_playground_europe_north1.name
#     access_config {
#     }
#   }
# }
