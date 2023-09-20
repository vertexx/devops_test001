variable "host_os" {
  type        = string
  description = "Windows or Linux"
}

variable "location" {
  type        = string
  default     = "Southeast Asia"
  description = "Azure Region"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
  description = "VM Size"
}

variable "vm_size2" {
  type        = string
  default     = "Standard_B1ms"
  description = "VM Size"
}

variable "network_address_space" {
  type        = list(any)
  default     = ["10.4.0.0/16"]
  description = "Virtual Network Address Space"
}

variable "network_subnet" {
  type        = list(any)
  default     = ["10.4.0.0/24"]
  description = "Virtual Network Subnet"
}

variable "common_tags" {
  type        = map(any)
  description = "Common Tags"
  default = {
    Environment = "devops_test"
  }
}

variable "nsgr_source_address_prefix" {
  type        = string
  default     = "*"
  description = "Network Security Group Rule Source Address Prefix"
}