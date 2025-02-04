aws_region = "us-west-2"

vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-west-2a", "us-west-2b"]
security_groups = ["sg-09c3b12ec1c311254"]
repo_name = "my-app-repo"
cluster_name = "my-ecs-cluster"
task_name = "my-task"
appoinment_container_name = "appointment-container"
image_url = "183114607892.dkr.ecr.us-west-2.amazonaws.com/appointment-service:latest"
task_memory = 1024
task_cpu = 512
log_group_name = "ecs-application-logs"
image_url_patient = "183114607892.dkr.ecr.us-west-2.amazonaws.com/patient-service:latest"
patient_container_name = "patient-container"
appointment_service_name = "appointment-service"
patient_service_name = "patient-service"
domain_name = "patients.example.com"