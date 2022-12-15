terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.35.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "devops_test_rg" {
  name     = "DevOps_Test_RG"
  location = "Southeast Asia"
  tags = {
    environment = "devops_test"
  }
}

resource "azurerm_virtual_network" "devops_test_vn" {
  name                = "DevOps_Test_VN"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  address_space       = ["10.4.0.0/16"]

  tags = {
    environment = "devops_test"
  }
}

resource "azurerm_subnet" "devops_test_vn_subnet" {
  name                 = "DevOps_Test_VN_Subnet"
  resource_group_name  = azurerm_resource_group.devops_test_rg.name
  virtual_network_name = azurerm_virtual_network.devops_test_vn.name
  address_prefixes     = ["10.4.0.0/24"]
}

resource "azurerm_network_security_group" "devops_test_nsg" {
  name                = "DevOps_Test_NSG"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location

  tags = {
    environment = "devops_test"
  }
}

resource "azurerm_network_security_rule" "devops_test_nsr_01" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "183.89.0.0/16"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.devops_test_rg.name
  network_security_group_name = azurerm_network_security_group.devops_test_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "devops_test_snsga" {
  subnet_id                 = azurerm_subnet.devops_test_vn_subnet.id
  network_security_group_id = azurerm_network_security_group.devops_test_nsg.id
}

resource "azurerm_public_ip" "devops_test_pub_ip" {
  name                = "DevOps_Test_PubIP"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "devops_test"
  }
}

resource "azurerm_network_interface" "devops_test_nic_01" {
  name                = "DevOps_Test_NIC_01"
  resource_group_name = azurerm_resource_group.devops_test_rg.name
  location            = azurerm_resource_group.devops_test_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.devops_test_vn_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_test_pub_ip.id
  }

  tags = {
    environment = "devops_test"
  }
}

resource "azurerm_linux_virtual_machine" "devops_test_vm_01" {
  name                  = "DevOps-Test-VM-01"
  resource_group_name   = azurerm_resource_group.devops_test_rg.name
  location              = azurerm_resource_group.devops_test_rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.devops_test_nic_01.id]

#   custom_data = filebase64("customdata.tpl")

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

#   provisioner "local-exec" {
#     command = templatefile("${var.host_os}-ssh-script.tpl", {
#       hostname     = self.public_ip_address,
#       user         = "adminuser",
#       identityfile = "~/.ssh/id_rsa"
#     })
#     interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
#   }

  tags = {
    environment = "devops_test"
  }
}

# data "azurerm_public_ip" "mtc-pub-ip" {
#   name                = azurerm_public_ip.mtc-ip.name
#   resource_group_name = azurerm_resource_group.mtc-rg.name
# }

# output "public_ip_address" {
#   value = "${azurerm_linux_virtual_machine.mtc-vm.name}: ${data.azurerm_public_ip.mtc-pub-ip.ip_address}"
# }