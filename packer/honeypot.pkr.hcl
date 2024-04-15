packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "debian-honey-image" {
  azure_tags = {
    environment = "dev"
    project     = "tcc"
    team        = "alface"
  }
  image_offer                       = "debian-11"
  image_publisher                   = "debian"
  image_sku                         = "11-gen2"
  managed_image_name                = "tcc-honey-image"
  managed_image_resource_group_name = "tcchoneypotsrg"
  build_resource_group_name         = "tcchoneypotsrg"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS2_v2"
  client_id                         = ""
  client_secret                     = ""
  tenant_id                         = ""
  subscription_id                   = ""
}

build {
  sources = ["source.azure-arm.debian-honey-image"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl git",
      "sudo snap install docker",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER",
      "sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync",
      "git clone https://github.com/telekom-security/tpotce.git /home/adminuser/tpotce"
    ]
    inline_shebang = "/bin/sh -x"
  }
}