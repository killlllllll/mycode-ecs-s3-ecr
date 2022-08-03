resource "aws_ecs_cluster" "main" {
  name = "${var.cluster_name}-${var.env}"
}

resource "aws_ecr_repository" "ecr" {
  name = "${var.repo_name}-${var.env}"
  
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_image_on_push

  }
}  

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
{
    "rules": [
        {
           "rulePriority": 1,
           "description": "Expire images more than 5",
           "selection": {
               "tagStatus": "any",
               "countType": "imageCountMoreThan",
               
               "countNumber": 5
           },
           "action": {
               "type": "expire"
           }
       }
    ]
}
EOF
}

resource "aws_ecs_task_definition" "app" {
      family = "${var.cluster_name}-${var.env}"
      requires_compatibilities = ["FARGATE"]
      network_mode             = "awsvpc"
      execution_role_arn       = "arn:aws:iam::991008360267:role/example-ecs-task-execution"
      cpu                      = var.fargate_cpu
      memory                   = var.fargate_memory

      container_definitions =  <<EOF
[{
	"name": "${var.container_name}",
	"image": "${var.accountid}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.repo_name}-${var.env}:latest",
	"portMappings": [
	  {
		"containerPort": ${var.container_port},
		"protocol": "tcp"
	  }
	],
	"essential": true,
	"command": [],
	"volumes": [],
	 "mountPoints": [],
	  "logConfiguration": {
	  "logDriver": "awslogs",
	  "options": {
		  "awslogs-group": "/ecs/${var.container_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
	  }
	}
  }
]
  EOF
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  health_check_grace_period_seconds  = var.health_check
  lifecycle {
    ignore_changes = [
        desired_count, 
        task_definition
        ]
  }
network_configuration {
    security_groups  =  ["sg-09a741fa74e1640d2"]
    subnets         =  ["subnet-f7b2f1bb", "subnet-e650c59d", "subnet-1f4f5277"]
    assign_public_ip = true
  }


 load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:ap-south-1:991008360267:targetgroup/new-tg-1/5519b74f939c0ad7"
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  acl = var.acl
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [ 
        "s3:GetObject"
       ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}",
        "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*"
      ]
    }
  ]
}
EOF
}

