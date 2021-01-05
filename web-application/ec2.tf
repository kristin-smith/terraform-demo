resource "aws_instance" "web-application"  {
    ami                          = "ami-03368e982f317ae48"
    associate_public_ip_address  = true
    availability_zone            = "us-east-1d"
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    instance_type                = "t2.micro"
    key_name                     = "web-application-key"
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
    key_name    = "web-application-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYoaAek0Jz4TbsQTNHR+Kn6BCUmyHiX9AgMPReH7zcKAbOID+oKhSh3iwptzoOPrkprrO8fPTfjOgPgH68FYPzJc6UFAQxgpntuelBgAMQPX4VyoGlWhyGLqzoUy+Bsr8eXu7saO/UIWi3n5QlaD5QAa4Vf7A6IUcg+yNtVujR94BGHCbKaOUZRJZ7RmaQCUnpdvQ6YfHSNjBdm1/Hbkbul4qNho9OKVoMG8x+jeUK8xAF/sDo2kxY9ccIIHCf81uN54czZm9BBsOHasTEUgVuOlC5/fCwcBRRmc6ofkaLF9TICf+bYpDxqIkOGIixc1xUNDeDAtss/xOMWphDK7+d"
    tags        = {}
}