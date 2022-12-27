output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.devops_test_vm_01.name}: ${data.azurerm_public_ip.devops_test_pub_ip_data.ip_address}"
}

output "my_public_ip" {
  value = data.http.my_public_ip.response_body
}