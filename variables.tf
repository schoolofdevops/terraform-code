variable "ami" {
  description = "ami for the instance"
  default     = "ami-408c7f28"
}

variable "instance" {
  description = "instance parameters"
  type        = "map"

  default = {
    "type" = "t1.micro"
    "name" = "demo-server"
  }
}

variable "key_name" {
  description = "name of the key"
  default     = "web-admin-key"
}

variable "key_pub" {
  description = "content of public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4Q2TBuAD7ijkPjp+/Hl/QnrNo4hoZEz/l+UBsfvlDuJk8zfh0ivnQLtoYyXNuJ3/BjTVVIchrGo8CLZdTco//n+YBvMqgW4Wg5F92JNNkR5L5x04ELRUmC3ed1ZqbwrLmujzB33nMJ8Ld5dJjtS55KJa5MwkCaP7lqGicU2NgXe+if2DhCKW/lZyCpkkvRgmB7oEqj6aBWNjp+FMY4v6BtcmmB/+1Ry+GMvmZJO1EjSeUHAWCec3snX7TxJKHf4opwTHxknmhRKkz8+pS8rxyjiBeyncxP9jL9Tx/Zh6qmExCUfuhAWk87sjbb3j0enVs2LtzJOG9eBZ726wD83TJ vibe@vibes-MacBook-Air.local"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "ssh_pvtkey" {
  default = "~/.ssh/id_rsa"
}
