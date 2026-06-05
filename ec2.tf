resource "aws_instance" "main" {
  ami                    = "ami-02dd44faa40720bb8"
  instance_type          = "t2.large"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "aws1"

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = {
    Name        = "aws1"
    Environment = "production"
    Project     = "electrifying-australia"
  }
}

resource "aws_eip_association" "main" {
  instance_id   = aws_instance.main.id
  allocation_id = var.eip_allocation_id
}
