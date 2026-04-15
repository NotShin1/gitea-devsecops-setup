# Configure the DigitalOcean provider
terraform {
  required_providers {
    digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.0"
    }
  }
}
# Use DigitalOcean provider
provider "digitalocean" {
    token = var.do_token
}

# Create SSH key resource
resource "digitalocean_ssh_key" "gitea-key" {
    name = "gitea-devsecops-ssh-key"
    public_key = file(var.public_key_ssh)
}

# Create Droplet resource
resource "digitalocean_droplet" "gitea-devsecops-droplet" {
    image              = "ubuntu-22-04-x64"
    name               = "gitea-devsecops-droplet"
    region             = "sgp1"
    size               = "s-1vcpu-1gb"
    ssh_keys          = [digitalocean_ssh_key.gitea-key.fingerprint]
}

# Create Firewall resource
resource "digitalocean_firewall" "gitea-devsecops-firewall" {
    name = "gitea-devsecops-firewall"
    droplet_ids = [digitalocean_droplet.gitea-devsecops-droplet.id]

    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        # Allow SSH from anywhere (noted as a security risk, but necessary for Github Actions to access the Droplet)
        source_addresses = ["0.0.0.0/0"]
    }
    inbound_rule {
        protocol = "tcp"
        port_range = "80"
        source_addresses = ["0.0.0.0/0"]
    }
    inbound_rule {
        protocol = "tcp"
        port_range = "443"
        source_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "tcp"
        port_range = "53"
        destination_addresses = ["0.0.0.0/0"]
    } 
    outbound_rule {
        protocol = "udp"
        port_range = "53"
        destination_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "icmp"
        destination_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
        protocol = "tcp"
        port_range = "80"
        destination_addresses = ["0.0.0.0/0"]
    }
    outbound_rule {
      protocol = "tcp"
      port_range = "443"
      destination_addresses = ["0.0.0.0/0"]
    }
}