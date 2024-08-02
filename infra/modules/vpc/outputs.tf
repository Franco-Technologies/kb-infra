output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id

}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "vpc_endpoints" {
  value = {
    ecr_dkr = aws_vpc_endpoint.ecr_dkr.id
    ecr_api = aws_vpc_endpoint.ecr_api.id
    s3      = aws_vpc_endpoint.s3.id
    logs    = aws_vpc_endpoint.logs.id
  }
}

output "vpc_link_sg_id" {
  value = aws_security_group.vpc_link.id
}
