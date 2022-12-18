output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_01.name}: ${data.azurerm_public_ip.devops_test_pub_ip_data.ip_address}"
}