variable "do_token" {
    description = "DigitalOcean API token"
    type        = string
    sensitive  = true
}

variable "public_key_ssh" {
    description = "Public SSH key to be added to the Droplet"
    type        = string
}