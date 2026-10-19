module "cluster" {
  source = "../../modules/cluster"

  cluster_name = "status-page-dev"
  namespace    = "status-page"
}
