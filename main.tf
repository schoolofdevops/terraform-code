provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance["type"]}"
  key_name               = "web-admin-key"
  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]
  depends_on             = ["aws_key_pair.webserver_key"]

  tags {
    Name = "${var.instance["name"]}"
  }

  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.ssh_pvtkey)}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/user-data.sh",
      "/tmp/user-data.sh",
    ]

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.ssh_pvtkey)}"
    }
  }
}

resource "aws_security_group" "webserver_sg" {
  name = "webserver-sg"

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "webserver_key" {
  key_name   = "${var.key_name}"
  public_key = "${var.key_pub}"
}

output "webserver_ip" {
  value = "${aws_instance.webserver.public_ip}"
}

data "aws_db_instance" "database" {
  db_instance_identifier = "${var.rds_name}"
}

output "rds_endpoint" {
  value = "${data.aws_db_instance.database.address}"
}

output "rds_user" {
  value = "${data.aws_db_instance.database.master_username}"
}

output "rds_db" {
  value = "${data.aws_db_instance.database.db_name}"
}

resource "null_resource" "populate_db_01" {
  provisioner "local-exec" {
    command = "ssh ubuntu@${aws_instance.webserver.public_ip} 'sudo sed -i -e 's/DBHOST/${data.aws_db_instance.database.address}/g' /var/www/html/config.ini'"
  }

  provisioner "local-exec" {
    command = "ssh ubuntu@${aws_instance.webserver.public_ip} 'sudo sed -i -e 's/SQLUSER/${data.aws_db_instance.database.master_username}/g' /var/www/html/config.ini'"
  }

  provisioner "local-exec" {
    command = "ssh ubuntu@${aws_instance.webserver.public_ip} 'sudo sed -i -e 's/SQLPASSWORD/${var.rds_pass}/g' /var/www/html/config.ini'"
  }

  provisioner "local-exec" {
    command = "ssh ubuntu@${aws_instance.webserver.public_ip} 'sudo sed -i -e 's/SQLDBNAME/${data.aws_db_instance.database.db_name}/g' /var/www/html/config.ini'"
  }

  provisioner "local-exec" {
    command = "ssh ubuntu@${aws_instance.webserver.public_ip} 'sudo service apache2 restart'"
  }
}
