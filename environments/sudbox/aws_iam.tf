resource "aws_iam_role" "task_execution" {
  name = "${var.pj_name}-${var.env}-TaskExecution"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ecs.amazonaws.com",
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "task_execution" {
  name = "${var.pj_name}-${var.env}-TaskExecution"
  role = aws_iam_role.task_execution.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "GetParams",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "ssm:GetParameters"
        ],
        "Resource" : [
          aws_kms_key.application.arn,
          aws_ssm_parameter.app_key.arn,
          aws_ssm_parameter.mysql_password.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
