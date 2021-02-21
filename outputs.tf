output "eks_endpoint" {
  value = data.aws_eks_cluster.cluster_adv.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.cluster_adv.certificate_authority[0].data
}
