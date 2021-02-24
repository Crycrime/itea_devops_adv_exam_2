data "aws_eks_cluster" "cluster_adv" {
  name = module.itea-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster_adv" {
  name = module.itea-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster_adv.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_adv.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_adv.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "itea-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "itea-cluster"
  cluster_version = "1.17"
  subnets = [
    aws_subnet.itea-subpub1.id,
    aws_subnet.itea-subpub2.id,
    aws_subnet.itea-subpub3.id
  ]
  vpc_id = aws_vpc.itea-vpc.id

  worker_groups = [
    {
      name                          = "worker-1"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 2
      root_volume_type              = "gp2"
      additional_security_group_ids = [aws_security_group.itea-sg.id]
    },
    {
      name                          = "worker-2"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      root_volume_type              = "gp2"
      additional_security_group_ids = [aws_security_group.itea-sg.id]
    },
  ]


  worker_additional_security_group_ids = [aws_security_group.itea-sg.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}
