# config the gcp provider
provider "google" {
  project = "aibidia"
  credentials = file(“service_account_key.json”)
  region  = "us-central1"
  zone    = "us-central1-c"
}

# creating a virtual private network
resource “google-compute_network” “vpc_network” {
  name = “vpc”
  cidr_block = "1.0.0.0/10"
}

# Configure Internet Gateway
resource "google_compute_network" "default" {
  name = "aibidia-network"
  auto_create_subnetworks = false
}

# config public subnet
resource "google_compute_subnetwork" "public-subnetwor" {
  name          = "aibidia-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

# config private subnet
resource "google_compute_subnetwork" "private-subnetwork" {
  name          = "aibidia-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

# config health check
resource "google_compute_health_check" "hc" {
  name               = "aibidia-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

#config NAT Gateway
resource "google_compute_router_nat" "nat" {
  name = "my-router-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# config public routetable to allow all outbound traffic routed to the internet gateway.
resource "google_compute_route" "public_router" {
  name        = "network-route"
  dest_range  = "15.0.0.0/24"
  network     = google_compute_network.default.name
  next_hop_ip = "10.132.1.5"
  priority    = 100
}

# config private routetable to allow all outbound traffic routed to the internet gateway.
resource "google_compute_route" "private_router" {
  name        = "network-route"
  dest_range  = "15.0.0.0/24"
  network     = google_compute_network.default.name
  next_hop_ip = "10.132.1.5"
  priority    = 100
}

# config sec group
resource "google_compute_security_policy" "aibidia-policy" {
  name = "aibidia"

  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["9.9.9.0/24"]
      }
    }
    description = "Deny access to IPs in 9.9.9.0/24"
  }

  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
}

# create gcp instance
resource "google_service_account" "default" {
  account_id   = "service_account_id"
  display_name = "Service Account"
}

resource "google_compute_instance" "default" {
  name         = "aibidia"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

# gcp compute disk config
resource "google_compute_disk" "default" {
  name  = "aibidia-disk"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  image = "debian-9-stretch-v20200805"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

output "VPC_public_ip" {
   value = google_compute_network.Main.id
 }

output "VPC_Public_Subnet" {
   value = google_compute_subnetwork.PublicSubnet.id
 }

output "VPC_Private_Subnet" {
   value = google_compute_subnetwork.PrivateSubnet.id
 }

output "Public_Route_Table" {
   value = google_compute_route.PublicRouteTable.id
 }

output "Private_Route_Table" {
   value = google_compute_route.PrivateRouteTable.id
 }
