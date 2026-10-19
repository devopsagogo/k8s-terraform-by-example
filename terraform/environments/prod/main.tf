module "cluster" {
  source = "../../modules/cluster"

  cluster_name = "status-page-prod"
  namespace    = "status-page"
}
