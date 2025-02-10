#!/bin/bash
# SSM user didn't start in home dir, so go there
cd 
sudo yum update -y
sudo yum install docker containerd git screen -y
sudo usermod -a -G docker ec2-user
id ec2-user
sudo systemctl start docker
sudo systemctl enable docker
sleep 10
sudo usermod -a -G docker ssm-user
sudo usermod -a -G docker ec2-user
sudo systemctl restart docker

echo "Connecting to PostgreSQL at ${postgress_url}"
docker pull deepak8934/project-tracker:1
docker run -e DATABASE_URL=postgres://openproject:openproject@${postgress_url}/openproject  -p 8080:80 docker.io/deepak8934/project-tracker:1