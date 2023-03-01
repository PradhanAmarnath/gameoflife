resourse "aws_key_pair" "mykey_pair" {
	key_name = "newkey"
	public_key = file("mykey")
}

resourse "aws_instance" "myinstance" {
	ami = "ami-0c9978668f8d55984"
	instance_type = "t2.micro"
	key_name = aws_key_pair.mykey_pair.key_name
	tags = {
		Name = "gameoflife-app"
	}
	provisioner "file" {
		source = "gameoflife.sh"
		destination = "/tmp/gameoflife.sh"
	}

	provisioner "remote-exec" {
		inline = [
		"chmod u+x /tmp/gameoflife.sh",
		"sudo /tmp/gameoflife.sh"
		]
	}
	connection {
		user = "ec2-user"
		private_key = file("mykey")
		host = self.private_ip
	}
}
