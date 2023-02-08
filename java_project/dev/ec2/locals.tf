locals {
user_data_amazon = <<-EOT
  #!/bin/bash
  amazon-linux-extras install -y ansible2 java-openjdk11
  yum update -y
  yum install -y git docker
  usermod -aG docker ec2-user
  EOT
}

locals {
user_data_ubuntu = <<-EOT
  #!/bin/bash
  apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  add-apt-repository --yes --update ppa:ansible/ansible
  apt update
  apt install -y software-properties-common  
  apt install -y ansible default-jdk git docker-ce 
  usermod -aG docker ubuntu
  EOT
}
