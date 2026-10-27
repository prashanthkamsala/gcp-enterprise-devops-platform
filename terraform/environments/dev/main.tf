module "network" {
  source = "../../modules/network"

  network_name = "devops-lab-vpc"
  subnet_name  = "devops-lab-subnet"
  region       = var.region

  node_cidr    = "10.20.0.0/24"
  pod_cidr     = "10.21.0.0/18"
  service_cidr = "10.22.0.0/22"
}

module "gke" {
  source = "../../modules/gke"

  project_id        = var.project_id
  cluster_name      = "devops-lab-gke"
  zone              = var.zone
  network_id        = module.network.network_id
  subnet_id         = module.network.subnet_id
  node_machine_type = "e2-standard-2"
  admin_cidr        = var.admin_cidr
}