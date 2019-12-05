#### user_data will not work with custom images
provider "aws" {
	region = "us-west-2"
        max_retries = 1
}

# locals {
#   user_data = <<EOF
# #!/bin/bash
# echo "Hello Terraform!"
# EOF
# }



resource "aws_instance" "my-instance" {
	#ami = "ami-298edd51"
        ami = "ami-0c5204531f799e0c6"
	instance_type = "t2.micro"
        #vpc_id = "vpc-d67dc4b0"
	key_name = "8KMILES-AWS-MS-OPERATIONS-KEY"
	tags = {
		Name = "Tf-test-user-data123"	
	}
        vpc_security_group_ids = [ "sg-11d0ce6b" ]
        subnet_id = "subnet-1abf5252"
        # user_data = file("user-data.txt")
        #user_data_base64 = base64encode(local.user_data)

provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
  #### Copy a local file to ec2 instance
provisioner "file" {
    source      = "kalyani.txt"
    destination = "/tmp/kalyani/kalyani.txt"
}


  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = ""
    private_key = file("/Users/thummapk/Documents/keys/8KMILES-AWS-MS-OPERATIONS-KEY.pem")
    host = self.private_ip
  }
}
#  data "aws_instance" "myec2" {
#    filter {
#     name   = "tag:Name"
#     values = ["Tf-test-user-data123"]
#   }
# }

##############################
output "instance_ip_addr" {
  value       = aws_instance.my-instance.private_ip
  description = "The private IP address of the main server instance."
}
