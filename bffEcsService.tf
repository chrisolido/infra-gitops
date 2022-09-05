resource "aws_ecs_service" "bffMobileService" {
  name            = "bffMobileService"
  cluster         = aws_ecs_cluster.bffMobileClusterDev.id
  task_definition = aws_ecs_task_definition.bffMobileService.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs_task_role.arn
  depends_on      = [aws_iam_role.ecs_task_execution_role]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.dev-bff-service-target-group.arn
    container_name   = "web"
    container_port   = 3000
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [ap-southeast-1a, ap-southeast-1b]"
  }
}

resource "aws_lb_target_group" "dev-bff-service-target-group" {
  name        = "dev-bff-service-target-group"
  target_type = "alb"
  port        = 3000
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  }