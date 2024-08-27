resource "google_compute_network" "test-network" {
  name = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test-subnet" {
  name = "test-subnet"
  ip_cidr_range = "149.111.0.0/16"
  region = var.project.region
  network = google_compute_network.test-network.id
}

resource "google_compute_instance" "test-vm" {
  name="test-vm"
  machine_type = "e2-small"
  zone="us-central1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size=10
      type="pd-standard"
    }
  }
  network_interface {
    network = google_compute_network.test-network.id
    subnetwork = google_compute_subnetwork.test-subnet.id
  }

  tags = ["http-server", "https-server"]

  metadata = {
    "gce-container-declaration" = <<-EOT
    spec:
        containers:
            -name: my-container
            image: us-central1-docker.pkg.dev/game-app-433321/game-repo/game-app
            securityContext:
                privileged: false
        restartPolicy: Always
    EOT
  }
}

resource "google_compute_firewall" "default-allow-http" {
    name= "default-allow-http"
    network = "test-network"
    depends_on = [ google_compute_network.test-network ]
    allow {
        protocol = "tcp"
        ports =["8080", "80", "443","22"]
    }
    source_tags = ["http-server"]
    source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "default-allow-https" {
    name= "default-allow-https"
    network = "test-network"
    depends_on = [ google_compute_network.test-network ]
    allow {
        protocol = "tcp"
        ports =["8080", "80", "443","22"]
    }
    source_tags = ["https-server"]
    source_ranges = ["35.235.240.0/20"]
}