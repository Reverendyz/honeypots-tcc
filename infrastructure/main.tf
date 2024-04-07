locals {
  name = "honeypots"
  tags = {
    environment = "dev"
    project     = "tcc"
    team        = "alface"
  }
}

data "azurerm_resource_group" "main_rg" {
  name = "tcchoneypotsrg"
}

resource "azurerm_virtual_network" "example" {
  name                = "network-test-vm"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    public_ip_address_id = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.example.id
  }
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  allocation_method   = "Static"

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  computer_name       = "honeypot"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 100
    name                 = "test-disk"
  }

  source_image_id = "/subscriptions/d2dacdf5-ba75-4a92-9880-16a05d154257/resourceGroups/tcchoneypotsrg/providers/Microsoft.Compute/images/tcc-honey-image"
}