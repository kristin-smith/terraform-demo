resource "aws_cloudwatch_event_rule" "morning_reminder" {
    description         = "send a good morning text every day"
    is_enabled          = true
    name                = "morning-alarm"
    schedule_expression = "cron(0 6 * * ? *)"
    tags                = {
        Name = "messaging-application"
    }
}

resource "aws_cloudwatch_event_target" "morning_reminder_lambda" {
    arn       = "arn:aws:lambda:us-east-1:902238724981:function:morning-alarm"
    rule      = aws_cloudwatch_event_rule.morning_reminder.name
    target_id = "Id1819835059738"
}