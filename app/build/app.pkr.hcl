packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "app" {
  ami_name      = "gr-app-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  # Local user profile for automation
  profile = "landonkt"
  ###################################
  #Remove comment for debugging to save on resources
  #skip_create_ami = true
  ###################################
  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
  launch_block_device_mappings {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = "1"
    delete_on_termination = true
  }
  source_ami_filter {
    filters = {
      name = "amzn2-ami-kernel-5.10-hvm*"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"
  associate_public_ip_address = true
  ssh_interface = "public_ip"
  security_group_filter {
    filters = {
      "tag:name": "main-gr"
    }
  }
  vpc_filter {
    filters = {
      "tag:name": "main-gr"
    }
  }
  subnet_filter {
    filters = {
      "tag:name": "main-gr"
    }
    most_free = true
    random = false

  }

}

build {
  name    = "gr-app-build"
  sources = [
    "source.amazon-ebs.app"
  ]
  provisioner "shell" {
    inline = ["sudo amazon-linux-extras install epel;"]
  }
  provisioner "ansible" {
    playbook_file   = "./app.yml"
  }
  provisioner "inspec" {
    profile = "inspec/app"
    extra_arguments = [ "--chef-license=accept-silent", "--sudo" ]
  }
  provisioner "shell"{
    inline =  ["sudo rm -f ~/.ssh/authorized_keys; sudo rm -f /root/.ssh/authorized_keys; sudo rm -rf /tmp/*"]
  }
}
