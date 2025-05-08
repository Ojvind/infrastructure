# resource "google_compute_instance" "vm_instance" {
#   name         = "terraform-instance"
#   zone         = "europe-north1-a"
#   machine_type = "e2-medium"

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


resource "google_compute_instance" "wtf_instance_4" {
  name         = "wtf-instance-4"
  machine_type = "e2-medium"
  zone         = "europe-north1-a"
  tags         = ["test-instance", "lovlla", "rdp-enabled"]
      
  labels = {
    app        = "test-instance"
    costcenter = "lovlla-ab"
  }

  allow_stopping_for_update = true

  boot_disk {
    auto_delete = false

    initialize_params {
      size  = 100
      image = "windows-2019"
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = google_compute_network.this.name
    subnetwork = google_compute_subnetwork.gcp_playground_europe_north1.name
    access_config {
    }
  }

  service_account {
    email  = google_service_account.lovlla.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  enable_display = true

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}
