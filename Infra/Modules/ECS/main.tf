resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "appointment_service" {
  family                   = var.task_name
  container_definitions    = jsonencode([{
    name       = var.container_name
    image      = var.image_url
    memory     = var.task_memory
    cpu        = var.task_cpu  # Make sure this is an integer
    essential  = true
    portMappings = [
      {
        containerPort = 3001
        hostPort      = 3001
        protocol      = "tcp"
      }
    ]
  }])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role

  # Task-level CPU and Memory
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  tags = {
    Name = var.task_name
  }
}


resource "aws_ecs_task_definition" "patient_service" {
  family                   = var.task_name
  container_definitions    = jsonencode([{
    name       = "patient-service"
    image      = var.image_url_patient
    memory     = var.task_memory
    cpu        = var.task_cpu  # Make sure this is an integer
    essential  = true
    portMappings = [
      {
        containerPort = 3002
        hostPort      = 3002
        protocol      = "tcp"
      }
    ]
  }])

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role

  # Task-level CPU and Memory
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  tags = {
    Name = var.task_name
  }
}


resource "aws_ecs_service" "app_service" {
  name = var.service_name
  cluster = var.cluster_id
  task_definition = var.task_definition
  desired_count   = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}