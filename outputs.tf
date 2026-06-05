output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = "3.1.184.18"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "s3_bucket" {
  value = aws_s3_bucket.main.id
}
