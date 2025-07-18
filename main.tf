provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 22.04 (for us-east-1)
  instance_type = "t2.micro"
  key_name      = "your-key-pair-name"

  security_groups = [aws_security_group.allow_web.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
            EOF

  tags = {
    Name = "WebApp"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow inbound traffic on custom port"

  ingress {
    from_port   = 1234
    to_port     = 1234
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
