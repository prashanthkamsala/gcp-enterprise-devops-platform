module "network" {
  source = "../../modules/network"

  network_name = "devops-lab-vpc"
  subnet_name  = "devops-lab-subnet"
  region       = var.region

  node_cidr    = "10.20.0.0/24"
  pod_cidr     = "10.21.0.0/18"
  service_cidr = "10.22.0.0/22"
}