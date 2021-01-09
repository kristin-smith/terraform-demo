resource "aws_lambda_function" "morning_reminder_lambda" {
    function_name                  = "morning-alarm"
    filename                       = "messaging-application/lambda-function.js.zip"
    handler                        = "index.handler"
    layers                         = []
    memory_size                    = 128
    reserved_concurrent_executions = -1
    role                           = aws_iam_role.iam_for_lambda.arn
    runtime                        = "nodejs12.x"
    tags                           = {}
    timeout                        = 3

    timeouts {}

    tracing_config {
        mode = "PassThrough"
    }
}