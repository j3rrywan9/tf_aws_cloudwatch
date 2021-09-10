resource "aws_sns_topic" "cw_demo_alerts" {
  name = "cw-demo-alerts"

  tags = {
    Terraform    = "true"
  }
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.cw_demo_alerts.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.cw_demo_alerts.arn,
    ]
  }
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.cw_demo_alerts.arn
  protocol  = "email"
  endpoint  = var.recipient
}

# Send notifications when a scaling event takes place
resource "aws_autoscaling_notification" "asg_notifications" {
  topic_arn = aws_sns_topic.cw_demo_alerts.arn

  group_names = [
    var.cw_demo_asg_name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}
