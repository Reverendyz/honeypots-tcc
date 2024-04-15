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
  client_id                         = "c05b77e7-3f6e-47d7-9f66-a35e1a909485"
  client_secret                     = "VEQ8Q~_IQwcmdH4LXTqkMza~.baQoSBi5lNbEbaO"
  tenant_id                         = "8a1ef6c3-8324-4103-bf4a-1328c5dc3653"
  subscription_id                   = "d2dacdf5-ba75-4a92-9880-16a05d154257"
}

build {
  sources = ["source.azure-arm.debian-honey-image"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl",
      "sudo snap install docker",
      "sudo groupadd docker",
      "sudo usermod -aG docker $USER",
      "sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync",
    ]
    inline_shebang = "/bin/sh -x"
  }
}