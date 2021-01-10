resource "aws_instance" "web-application"  {
    ami                          = "ami-03368e982f317ae48"
    associate_public_ip_address  = true
    availability_zone            = "us-east-1d"
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    instance_type                = "t2.micro"
    key_name                     = "terraform-demo-2021"
    source_dest_check            = true
    subnet_id                    = "subnet-001f172e"
    tags                         = {
        "Name" = "web-application"
    }
    tenancy                      = "default"
    volume_tags                  = {
        "Name" = "web-application"
    }
    vpc_security_group_ids       = [
        aws_security_group.web-application-http.id,
    ]

    credit_specification {
        cpu_credits = "standard"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 300
        volume_size           = 100
        volume_type           = "gp2"
    }

    timeouts {}
}

resource "aws_key_pair" "demo-key" {
    key_name    = "terraform-demo-2021"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7/+NRLhpD3m2S+NwyfVvKc6TFixNawS92GdQzxUQD5feJODfVrWt33w6zh77awwxjOFDQoJ4o4XTfUFdpEqNysMyxgcnW+qzpxPg2xEcl6AnwUsMku6H7TsoZfYX7wa0IbyTPfJuSY7CcQCz4AiiNU1WzBbK9MxSfR2Kp/esxPwkwicoeWAqAJ3UzyBWVmD91nvj7V+1ZE2lzMdvwc1tzOtiUUbrv6AGdMl5C3AiS+S1m5QcnJS9dhXvYQWB3cF3JB5oAfiUfvjeRDqD0iT4l0oq6n6EXnkP/RooXa2pee9StVHoYe4Rgwmwhzi6xSwlf/ceKGiyLrFmmBxvGxGLoKeTPNHA7hF0OF5eiF1KI2yy/5WPt5HSFXnj9lmod2xcBdCfUl0F1d60ZlQw7KMUzI8Y5hRobbBPCuyvCY8VAPFXskCNHXXqhD/4j61qa0E1iOpKly/z9M0XDpdJCIsaLZ1Eej+z3iucNHb+JHnRMQV6xKlG66rUzULq1CTVbQ/8= noname"
    tags                = {
        Name = "web-application"
    }
}