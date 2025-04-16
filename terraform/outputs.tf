output "aws_vpc_id" { value = aws_vpc.main.id }
output "azure_vnet_name" { value = azurerm_virtual_network.main.name }
output "aws_instance_public_ip" { value = aws_instance.web.public_ip }

