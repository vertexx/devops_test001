locals {
  nsg_rules = {
    ssh = {
      name                   = "ssh"
      priority               = 100
      protocol               = "Tcp"
      destination_port_range = "22"
      source_address_prefix  = "*"
    }
    www = {
      name                   = "www"
      priority               = 150
      protocol               = "Tcp"
      destination_port_range = "80"
      source_address_prefix  = "*"
    }
    https = {
      name                   = "https"
      priority               = 200
      protocol               = "Tcp"
      destination_port_range = "443"
      source_address_prefix  = "*"
    }
    mysql = {
      name                   = "mysql"
      priority               = 250
      protocol               = "Tcp"
      destination_port_range = "3306"
      source_address_prefix  = "20.204.105.229"
    }
    loki = {
      name                   = "loki"
      priority               = 300
      protocol               = "Tcp"
      destination_port_range = "3100"
      source_address_prefix  = "20.204.91.145"
    }
    nodeexp = {
      name                   = "nodeexp"
      priority               = 310
      protocol               = "Tcp"
      destination_port_range = "9100"
      source_address_prefix  = "20.204.105.229"
    }
    influxdb = {
      name                   = "influxdb"
      priority               = 315
      protocol               = "Tcp"
      destination_port_range = "8086"
      source_address_prefix  = "202.184.20.197"
    }
    elastic = {
      name                   = "elastic"
      priority               = 320
      protocol               = "Tcp"
      destination_port_range = "9200"
      source_address_prefix  = "202.184.20.197"
    }
  }
}