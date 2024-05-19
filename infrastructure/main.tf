locals {
  name         = "honeypots"
# subscription = "0978-a9s89d87-98978"
  tags = {
    environment      = "dev"
    project          = "tcc"
    team             = "alface"
    maintainer       = "Felipe Santos"
    maintainer_email = "s.moreira5@pucpr.edu.br"
  }
}

data "azurerm_resource_group" "main_rg" {
  name = "tcchoneypotsrg"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  size                = "Standard_DS3_v2"
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
    disk_size_gb         = 300
    name                 = "test-disk"
  }

  source_image_id = "/subscriptions/${local.subscription}/resourceGroups/tcchoneypotsrg/providers/Microsoft.Compute/images/tcc-honey-image"
}
