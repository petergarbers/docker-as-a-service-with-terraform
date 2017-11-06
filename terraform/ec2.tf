resource "aws_instance" "docker-as-a-service" {
  ami           = "${var.ec2_ami_id}"
  instance_type = "${var.ec2_instance_size}"
  key_name = "${aws_key_pair.docker-as-a-service.id}"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.docker-as-a-service.id}"]

  tags {
    Name = "Peters test runit terraform"
  }

  root_block_device {
    volume_size = "10"
  }

  provisioner "file" {
    source = "${var.runit_executeable}"
    destination = "/home/ubuntu/nginx.sh"
    connection {
      user = "ubuntu"
      private_key = "${file("${var.identity_location}")}"
      host = "${self.public_ip}"
    }
  }

  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
      private_key = "${file("${var.identity_location}")}"
      host = "${self.public_ip}"
    }
    inline = [
      "curl -fsSL get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker $(whoami)",
      "sudo apt-get install runit apt-transport-https ca-certificates curl software-properties-common -y",
      "chmod +x /home/ubuntu/nginx.sh",
      "sudo mkdir -p /etc/service/nginx",
      "sudo chmod +x /home/ubuntu/nginx.sh",
      "sudo cp /home/ubuntu/nginx.sh /etc/service/nginx/run",
    ]
  }
}

resource "aws_security_group" "docker-as-a-service" {
  name        = "${var.appname}-${var.prefix}-docker-as-a-service"
  description = "docker as a service"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "docker-as-a-service ip" {
  value = "${aws_instance.docker-as-a-service.public_ip}"
}