terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "../../Modules/VPC"
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  availability_zones = var.availability_zones
}

module "iam" {
  source = "../../Modules/IAM"
}

module "ecr" {
  source    = "../../Modules/ECR"
  repo_name = var.repo_name
}

module "ecs" {
  source          = "../../Modules/ECS"
  cluster_name    = var.cluster_name
  task_name       = var.task_name
  container_name  = var.container_name
  image_url       = var.image_url
  image_url_patient = var.image_url_patient
  task_memory     = var.task_memory
  task_cpu        = var.task_cpu
  execution_role  = module.iam.ecs_task_role_arn
  service_name    = var.service_name
  cluster_id      = module.ecs.cluster_id
  task_definition = module.ecs.task_definition_arn
  subnets         = module.vpc.private_subnets
  security_groups = module.alb.sg_id
}

module "alb" {
  source      = "../../Modules/ALB"
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.public_subnets
}

module "monitoring" {
  source         = "../../Modules/Cloudwatch"
  log_group_name = var.log_group_name
}
