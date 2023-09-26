locals {
  nsg_rules = {
    ssh = {
      name                   = "ssh"
      priority               = 100
      protocol               = "Tcp"
      destination_port_range = "22"
    }
    www = {
      name                   = "www"
      priority               = 150
      protocol               = "Tcp"
      destination_port_range = "80"
    }
    https = {
      name                   = "https"
      priority               = 200
      protocol               = "Tcp"
      destination_port_range = "443"
    }
    mysql = {
      name                   = "mysql"
      priority               = 250
      protocol               = "Tcp"
      destination_port_range = "3306"
    }
    loki = {
      name                   = "loki"
      priority               = 300
      protocol               = "Tcp"
      destination_port_range = "3100"
    }
  }
}