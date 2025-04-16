# AWS VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "multi-cloud-vpc" }
}

# Azure Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "multi-cloud-vnet"
  location            = var.azure_location
  resource_group_name = "multi-cloud-rg"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "my-subnet"
  resource_group_name  = "multi-cloud-rg"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure Network Interface
resource "azurerm_network_interface" "main" {
  name                = "vm-nic"
  location            = var.azure_location
  resource_group_name = "multi-cloud-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

# AWS EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Change AMI as needed
  instance_type = "t2.micro"
  subnet_id     = aws_vpc.main.id
}

# Azure Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "my-vm"
  location              = var.azure_location
  resource_group_name   = "multi-cloud-rg"
  network_interface_ids = [azurerm_network_interface.main.id]  # Ensure this is correctly referenced
  size                  = "Standard_B1s"

  admin_username = "adminuser"
  disable_password_authentication = true

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
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


