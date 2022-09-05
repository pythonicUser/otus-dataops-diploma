terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_cloud_folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "project-network" {
  name = "project-network"
}

resource "yandex_vpc_subnet" "subnet-project-db" {
  name           = "subnet-project-db"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.project-network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet-project-airflow" {
  name           = "subnet-project-airflow"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.project-network.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet-project-redash" {
  name           = "subnet-project-redash"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.project-network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

resource "yandex_compute_instance" "db-vm" {
  name = "db-vm"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81u2vhv3mc49l1ccbb"
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-project-db.id
    nat       = true
}
  metadata = {
    user-data = "${file("meta.txt")}"
}
  
}

resource "yandex_compute_instance" "airflow-vm" {
  name = "airflow-vm"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81u2vhv3mc49l1ccbb"
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-project-airflow.id
    nat       = true
}
  metadata = {
    user-data = "${file("meta.txt")}"
}
  
}

resource "yandex_compute_instance" "redash-vm" {
  name = "mongo-hw-vm"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd81u2vhv3mc49l1ccbb"
      size = 50
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-project-redash.id
    nat       = true
}
  metadata = {
    user-data = "${file("meta.txt")}"
}
  
}


output "internal_ip_address_db_project" {
  value = yandex_compute_instance.db-vm.network_interface.0.ip_address
}

output "external_ip_address_db_project" {
  value = yandex_compute_instance.db-vm.network_interface.0.nat_ip_address
}

output "internal_ip_address_airflow" {
  value = yandex_compute_instance.airflow-vm.network_interface.0.ip_address
}

output "external_ip_address_aiflow" {
  value = yandex_compute_instance.airflow-vm.network_interface.0.nat_ip_address
}

output "internal_ip_address_redash" {
  value = yandex_compute_instance.redash-vm.network_interface.0.ip_address
}

output "external_ip_address_redash" {
  value = yandex_compute_instance.redash-vm.network_interface.0.nat_ip_address
}
