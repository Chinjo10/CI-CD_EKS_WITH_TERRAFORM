
################################################################################
# CONFIGURE BACKEND
################################################################################

terraform {
  required_version = ">=1.1.0" 

  backend "s3" {
    bucket         = "kojitechs.aws.eks.with.terraform.tf" # s3 bucket 
    key            = "path/env/kojitechs-ci-cd-demo-infra-pipeline-tf"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = "true"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

################################################################################
# PROVIDERS BLOCK
################################################################################

provider "aws" {
  region = "us-east-1"
}

################################################################################
# LOCALS BLOCK
################################################################################

locals {
  vpc_id   = module.vpc.vpc_id
}

################################################################################
# DATA SOURCE BLOCK
################################################################################

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

################################################################################
# MODULES BLOCK
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.component_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"] # Data source
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    Type                                        = "Public Subnets"
    "kubernetes.io/role/elb"                    = 1
    "kubernetes.io/cluster/${var.component_name}-eks-demo" = "shared"
  }
  private_subnet_tags = {
    Type                                        = "private-subnets"
    "kubernetes.io/role/internal-elb"           = 1
    "kubernetes.io/cluster/${var.component_name}-eks-demo" = "shared"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

}

################################################################################
# RESOURCE BLOCK
################################################################################

resource "aws_instance" "jenkins-server" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.large"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  user_data = file("${path.module}/templates/jenkins.sh")  

  tags = {
    Name = "jenkins-server"
  }
  lifecycle {
    ignore_changes = [
        user_data,
    ]
  }
}

resource "aws_instance" "sonarqube-server" {
  ami           = data.aws_ami.ami.id
  instance_type ="t3.large"
  subnet_id = module.vpc.public_subnets[0] # private ? NAT OR ssm-endpoint
  vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
   user_data = file("${path.module}/templates/sonarqube.sh") 

  tags = {
    Name = "sonarqube-server"
  }
}

resource "aws_ecr_repository" "this" {
  name                 = "${var.component_name}-kojitechs-webapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}