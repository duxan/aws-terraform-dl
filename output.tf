output "connection_string" {
  value = "ssh -i ${aws_key_pair.generated_key.key_name}.pem ubuntu@${aws_instance.jupyter.public_dns}"
}

output "jupyter_url" {
  value = "http://${aws_instance.jupyter.public_dns}:8888/"
}
