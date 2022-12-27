locals {
  nsg_rules = {
    ssh = {
      name                   = "ssh"
      priority               = 100
      protocol               = "Tcp"
      destination_port_range = "22"
    }
    www = {
      name                   = "www-java-app"
      priority               = 150
      protocol               = "Tcp"
      destination_port_range = "7071"
    }
    nexus = {
      name                   = "nexus"
      priority               = 200
      protocol               = "Tcp"
      destination_port_range = "8081"
    }
    nexus-docker = {
      name                   = "nexus-docker"
      priority               = 300
      protocol               = "Tcp"
      destination_port_range = "8083"
    }
  }
}