resource "aws_key_pair" "docker-as-a-service" {
  key_name   = "peter-id"
  public_key = "#{var.public_key}"
}