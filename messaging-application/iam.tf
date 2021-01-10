resource "aws_iam_role" "iam_for_lambda" {
    assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "lambda.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "morning-alarm-role"
    path                  = "/service-role/"
    tags                = {
        Name = "messaging-application"
    }
}