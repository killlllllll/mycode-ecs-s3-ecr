provider "aws" {
 region = "ap-south-1"
}

module "react-spa-frontend-s3-cf" {
    source                 = "../cf"
    hosted_zone            = "cloudtoday.click" 
    domain_name            = "test.cloudtoday.click"
    acm_certificate_domain = "cloudtoday.click"
    zonid                  = "Z08978411J71TQQD321FO"
    env                    =  "prod123"
    acm_certificate        = "arn:aws:acm:us-east-1:991008360267:certificate/92f2310b-6c90-4f8c-bf3f-0afc9697c3c4"
    bucket_name            =  "coffeeindigo-ui"
    acl                    = "private"
    versioning             = "Enabled"
}


module "strapi-cms-ecs" {
    source                 = "../strapi"
    accountid              = "991008360267"
    aws_region             = "ap-south-1"
    security_groups        =  ["sg-09a741fa74e1640d2"]
    subnets                =  ["subnet-f7b2f1bb", "subnet-e650c59d", "subnet-1f4f5277"]
    targetgroup_arn        =  "arn:aws:elasticloadbalancing:ap-south-1:991008360267:targetgroup/new-tg-1/5519b74f939c0ad7"
    execution_role_arn     =  "arn:aws:iam::991008360267:role/example-ecs-task-execution"
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
