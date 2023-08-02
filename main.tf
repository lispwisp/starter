module "cert-manager" {
  depends_on = []
  source     = "./cert-manager/def"
}

module "cert-manager-crd" {
  depends_on = []
  source     = "./cert-manager/crd"
}

module "cockroachdb" {
  depends_on = []
  source     = "./cockroachdb"
}

module "haproxy" {
  depends_on = []
  source     = "./haproxy"
}

module "kube-state-metrics" {
  depends_on = []
  source     = "./kube-state-metrics"
}

module "kubernetes-dashboard" {
  depends_on = []
  source     = "./kubernetes-dashboard"
}

module "monitoring" {
  depends_on = []
  source     = "./monitoring"
}

module "node-exporter" {
  depends_on = []
  source     = "./node-exporter"
}