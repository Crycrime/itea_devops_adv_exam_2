output "eks_endpoint" {
  value = data.aws_eks_cluster.cluster_adv.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.cluster_adv.certificate_authority[0].data
}

output "ec2_endpoint" {
  description = "The address of the EC2 instance"
  value       = aws_instance.ec2-instance.public_ip
}
