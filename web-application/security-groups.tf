resource "aws_security_group" "web-application-http" {
    description = "allows ssh and http access"
    egress {
        cidr_blocks      = [
            "0.0.0.0/0",
        ]
        description      = ""
        from_port        = 0
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        protocol         = "-1"
        security_groups  = []
        self             = false
        to_port          = 0
    }

    ingress {
        cidr_blocks      = [
            "0.0.0.0/0",
        ]
        description      = ""
        from_port        = 22
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        protocol         = "tcp"
        security_groups  = []
        self             = false
        to_port          = 22
    }

    ingress    {
        cidr_blocks      = [
            "0.0.0.0/0",
        ]
        description      = ""
        from_port        = 80
        ipv6_cidr_blocks = [
            "::/0",
        ]
        prefix_list_ids  = []
        protocol         = "tcp"
        security_groups  = []
        self             = false
        to_port          = 80
    }

    name        = "web-application-sg"
    tags        = {}
    vpc_id      = aws_default_vpc.default.id

    timeouts {}
}