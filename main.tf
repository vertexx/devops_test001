terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.73.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devops_test_rg" {
  name     = "DevOps-Test-RG"
  location = var.location
  tags     = merge(var.common_tags, { Name = "DevOps Test RG" })
}

resource "azurerm_virtual_network" "devops_test_vn" {
  name                = "DevOps-Test-VN"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  address_space       = var.network_address_space
  tags                = var.common_tags
}

resource "azurerm_subnet" "devops_test_vn_subnet" {
  name                 = "DevOps-Test-VN-Subnet"
  resource_group_name  = azurerm_resource_group.devops_test_rg.name
  virtual_network_name = azurerm_virtual_network.devops_test_vn.name
  address_prefixes     = var.network_subnet
}

resource "azurerm_network_security_group" "devops_test_nsg" {
  name                = "DevOps-Test-NSG"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  tags                = var.common_tags
}

resource "azurerm_network_security_rule" "devops_test_nsrules" {
  for_each               = local.nsg_rules
  name                   = each.key
  priority               = each.value.priority
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = each.value.protocol
  source_port_range      = "*"
  destination_port_range = each.value.destination_port_range
  source_address_prefix  = each.value.source_address_prefix
  # source_address_prefix       = data.http.my_public_ip.response_body
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.devops_test_rg.name
  network_security_group_name = azurerm_network_security_group.devops_test_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "devops_test_snsga" {
  subnet_id                 = azurerm_subnet.devops_test_vn_subnet.id
  network_security_group_id = azurerm_network_security_group.devops_test_nsg.id
}

resource "azurerm_public_ip" "devops_test_pub_ip" {
  name                = "DevOps-Test-Pub-IP"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  allocation_method   = "Static"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "devops_test_pub_ip2" {
  name                = "DevOps-Test-Pub-IP2"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  allocation_method   = "Static"
  tags                = var.common_tags
}

resource "azurerm_public_ip" "devops_test_pub_ip3" {
  name                = "DevOps-Test-Pub-IP3"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  allocation_method   = "Static"
  tags                = var.common_tags
}

resource "azurerm_network_interface" "devops_test_nic_01" {
  name                = "DevOps-Test-NIC-01"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.devops_test_vn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_test_pub_ip.id
  }
  tags = var.common_tags
}

resource "azurerm_network_interface" "devops_test_nic_02" {
  name                = "DevOps-Test-NIC-02"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.devops_test_vn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_test_pub_ip2.id
  }
  tags = var.common_tags
}

resource "azurerm_network_interface" "devops_test_nic_03" {
  name                = "DevOps-Test-NIC-03"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.devops_test_vn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_test_pub_ip3.id
  }
  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "devops_test_vm_01" {
  name                  = "DevOps-Test-VM-01"
  resource_group_name   = azurerm_resource_group.devops_test_rg.name
  location              = azurerm_resource_group.devops_test_rg.location
  size                  = var.vm_size
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.devops_test_nic_01.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-script-${var.host_os}.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "devops_test_vm_02" {
  name                  = "DevOps-Test-VM-02"
  resource_group_name   = azurerm_resource_group.devops_test_rg.name
  location              = azurerm_resource_group.devops_test_rg.location
  size                  = var.vm_size2
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.devops_test_nic_02.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-script-${var.host_os}.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "devops_test_vm_03" {
  name                  = "DevOps-Test-VM-03"
  resource_group_name   = azurerm_resource_group.devops_test_rg.name
  location              = azurerm_resource_group.devops_test_rg.location
  size                  = var.vm_size3
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.devops_test_nic_03.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-script-${var.host_os}.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
  tags = var.common_tags
}

data "azurerm_public_ip" "devops_test_pub_ip_data" {
  name                = azurerm_public_ip.devops_test_pub_ip.name
  resource_group_name = azurerm_resource_group.devops_test_rg.name
}

data "azurerm_public_ip" "devops_test_pub_ip2_data" {
  name                = azurerm_public_ip.devops_test_pub_ip2.name
  resource_group_name = azurerm_resource_group.devops_test_rg.name
}

data "azurerm_public_ip" "devops_test_pub_ip3_data" {
  name                = azurerm_public_ip.devops_test_pub_ip3.name
  resource_group_name = azurerm_resource_group.devops_test_rg.name
}

data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip"
}