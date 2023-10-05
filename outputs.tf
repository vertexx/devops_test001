output "public_ip_address1" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_01.name}: ${data.azurerm_public_ip.devops_test_pub_ip_data.ip_address}"
}

output "public_ip_address2" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_02.name}: ${data.azurerm_public_ip.devops_test_pub_ip2_data.ip_address}"
}

output "public_ip_address3" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_03.name}: ${data.azurerm_public_ip.devops_test_pub_ip3_data.ip_address}"
}

output "public_ip_address4" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_04.name}: ${data.azurerm_public_ip.devops_test_pub_ip4_data.ip_address}"
}

output "my_public_ip" {
  value = data.http.my_public_ip.response_body
}