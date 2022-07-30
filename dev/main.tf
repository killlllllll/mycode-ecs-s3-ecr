module "strapi-cms-ecs" {
    source           = "../../modules/services/strapi-cms-ecs/"
    accountid              = "991008360267"
    aws_region             = "ap-south-1"
    cluster_name           = "coffeeindigo-ecs"
    app_port               = 80
    fargate_cpu            = 1024
    fargate_memory         = 2048
    health_check           = 600
    service_name           = "myapp-service"
    container_name         = "myapp"
    container_port         = 80
    env                    = "dev123"
    repo_name              = "coffeeindigo-ecr"
    image_tag_mutability   = "IMMUTABLE"
    scan_image_on_push     = true
    desired_count          = 1
    bucket_name            =  "coffeeindigo123-bucket1"
    acl                    = "private"
    versioning             = "Enabled" 
}