output "droplet-ip" {
    description = "IPv4 address of the Droplet"
    value = digitalocean_droplet.gitea-devsecops-droplet.ipv4_address
}
output "droplet-id" {
    description = "Public ID of the Droplet"
    value = digitalocean_droplet.gitea-devsecops-droplet.id
}
output "ssh-connection-string" {
    description = "SSH connection string for the Droplet"
    value = "ssh root@${digitalocean_droplet.gitea-devsecops-droplet.ipv4_address}"
}