
output "jenkins-host-ip" {
    description = "Jenkins host public IP address"
    value = "http://${aws_instance.jenkins-server.public_ip}:8080"
}

output "sonarqube-host-ip" {
    description = "Jenkins host public IP address"
    value = "http://${aws_instance.sonarqube-server.public_ip}:9000"
}

output "aws-ecr-repo" {
    description = "the name of aws ecr repo"
    value = aws_ecr_repository.this.name
}

################################
# EKS Cluster Outputs
output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive = true
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster."
  value       = aws_iam_role.eks_master_role.name 
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = aws_iam_role.eks_master_role.arn
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Node group outputs
output "node_group_public_id" {
  description = "Node Group ID"
  value       = {for id, node_group in aws_eks_node_group.eks_nodegroup: id=> node_group.id }
}

output "node_group_public_arn" {
  description = "Node Group ARN"
  value       = {for arn, node_group in aws_eks_node_group.eks_nodegroup: arn=> node_group.arn }
}

output "node_group_public_status" {
  description = "Public Node Group status"
  value       = {for status, node_group in aws_eks_node_group.eks_nodegroup: status=> node_group.status }
}

output "node_group_public_version" {
  description = "Public Node Group status"
  value       = {for version, node_group in aws_eks_node_group.eks_nodegroup: version=> node_group.version }
}
