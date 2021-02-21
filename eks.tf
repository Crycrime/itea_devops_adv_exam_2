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
  #load_config_file       = false
  #version                = "~> 1.9"
}

module "itea-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "itea-cluster"
  cluster_version = "1.18"
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
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 1
      root_volume_type              = "gp2"
      additional_security_group_ids = [aws_security_group.itea-sg.id]
    },
  ]
}

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = data.aws_eks_cluster.cluster_adv.name
  node_group_name = "node_cluster"
  instance_types  = ["t3.medium"]
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [aws_subnet.itea-subpub1.id, aws_subnet.itea-subpub2.id, aws_subnet.itea-subpub2.id]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
