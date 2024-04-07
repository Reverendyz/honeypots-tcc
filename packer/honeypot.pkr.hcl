packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "custom-honey-image" {
  azure_tags = {
    environment = "dev"
    project     = "tcc"
    team        = "alface"
  }
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "brazilsouth"
  managed_image_name                = "tcc-honey-image"
  managed_image_resource_group_name = "tcchoneypotsrg"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS2_v2"
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
}

build {
  sources = ["source.azure-arm.custom-honey-image"]

  provisioner "shell" {
    inline          = [
      "apt-get update",
      "apt-get -y curl",
      "snap install docker",
      "sudo groupadd docker",
      "sudo usermod -aG docker useradmin",
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync",
      ]
    inline_shebang  = "/bin/sh -x"
  }
}