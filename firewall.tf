resource "google_compute_firewall" "allow_rdp" {
  name    = "allow-rdp"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["rdp-enabled"]

  description = "Allow RDP access on TCP port 3389 from anywhere"
}
