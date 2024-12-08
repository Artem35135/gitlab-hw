terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.129.0"
    }
  }

  required_version = "~>1.9.6"
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "ter-vm" {
  count       = 2
  name        = "ter-vm${count.index}"
  boot_disk {
    initialize_params {
      image_id = "fd82odtq5h79jo7ffss3"
      size     = 10
    }
  }

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = { user-data = "${file("users.yml")}" }
}

resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_target_group" "my-gp" {
  name      = "my-gp"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.ter-vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.ter-vm[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "balancer1" {
  name = "balancer1"
  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.my-gp.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "lb-ip" {
  value = yandex_lb_network_load_balancer.balancer1.listener
}
output "vm-ips" {
  value = tomap({
    for i in range(2) : 
    "ter-vm${i}" => yandex_compute_instance.ter-vm[i].network_interface[0].nat_ip_address
  })
}

