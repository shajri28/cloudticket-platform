output "vpc_id"                { value = aws_vpc.main.id }
output "public_subnet_ids"     { value = aws_subnet.public[*].id }
output "private_subnet_ids"    { value = aws_subnet.private[*].id }
output "ec2_security_group_id" { value = aws_security_group.ec2.id }
output "rds_security_group_id" { value = aws_security_group.rds.id }
output "db_subnet_group_name"  { value = aws_db_subnet_group.main.name }
output "s3_artifacts_bucket"   { value = aws_s3_bucket.artifacts.bucket }

output "ec2_public_ip" {
  description = "Elastic IP of the EC2 instance"
  value       = aws_eip.main.public_ip
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.main.id
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ~/.ssh/cloudticket ubuntu@${aws_eip.main.public_ip}"
}
