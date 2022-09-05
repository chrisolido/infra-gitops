resource "aws_kms_key" "bff-kms-key" {
  description             = "bff-kms-key"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "bffMobileClusterDevLog" {
  name = "bffMobileClusterDevLog"
}

resource "aws_ecs_cluster" "bffMobileClusterDev" {
  name = "bffMobileClusterDev"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.bff-kms-key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.bffMobileClusterDevLog.name
      }
    }
  }
}