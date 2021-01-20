resource "aws_budgets_budget" "messaging" {
    budget_type       = "COST"
    cost_filters      = {
        "TagKeyValue" = "user:Name$messaging-application"
    }
    limit_amount      = "20.0"
    limit_unit        = "USD"
    name              = "Monthly messaging budget"
    time_period_end   = "2087-06-15_00:00"
    time_period_start = "2021-01-01_00:00"
    time_unit         = "MONTHLY"

    cost_types {
        include_credit             = false
        include_discount           = true
        include_other_subscription = true
        include_recurring          = true
        include_refund             = false
        include_subscription       = true
        include_support            = true
        include_tax                = true
        include_upfront            = true
        use_amortized              = false
        use_blended                = false
    }

    notification {
        comparison_operator        = "GREATER_THAN"
        notification_type          = "ACTUAL"
        subscriber_email_addresses = [
            "accounting@dummyaccount.com",
        ]
        threshold                  = 80
        threshold_type             = "PERCENTAGE"
    }
}