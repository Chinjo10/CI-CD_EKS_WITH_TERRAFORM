#!/bin/bash
# Installing JAVA && Jenkins 
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
# Start jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
# Setup Jenkins to start at boot
sudo yum install git -y
sudo yum install python
sudo yum install python-pip
pip3 install ansible
# Installing Docker 
yum install docker -y
service docker start
sudo useradd dockeradmin
# sudo passwd dockeradmin TODO LIST
sudo usermod -aG docker dockeradmin
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock
# install Sonarqube scanner
mkdir sonnar-canna && cd sonnar-canna
sudo unzip sonar-scanner-cli-4.6.2.2472-linux.zip
sudo mv sonar-scanner-4.6.2.2472-linux  sonar-scanner-cli
sudo mv sonar-scanner-cli /opt/sonar/
# cd into /opt/sonar/conf and add format("http://%s:%s", aws_instance.SonarQubesinstance.public_ip, var.sonar_port)
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
# Installing maven
sudo su
mkdir /opt/maven && cd /opt/maven
wget https://mirror.lyrahosting.com/apache/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz
tar -xvzf apache-maven-3.8.7-bin.tar.gz
# echo  "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.302.b08-0.amzn2.M2_HOME=/opt/maven/apache-maven-3.8.4 M2=$M2_HOME/bin PATH=$PATH:$HOME/bin:$M2_HOME:$M2:$JAVA_HOME" > file10.1.x86_64  
# cat >> ~/.bash_profile 

 
# JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.302.b08-0.amzn2.0.1.x86_64
# M2_HOME=/opt/maven/apache-maven-3.8.7/bin
# M2=$M2_HOME/bin
# PATH=$PATH:$HOME/bin:$M2_HOME:$M2:$JAVA_HOME 
# export PATH

sudo useradd ansible
sudo useradd jenkins
sudo -u jenkins mkdir /home/jenkins.ssh
# install groovy 
sudo mkdir /usr/share/groovy
sudo wget wget https://archive.apache.org/dist/groovy/4.0.0-rc-1/distribution/apache-groovy-binary-4.0.0-rc-1.zip
unzip apache-groovy-binary-4.0.0-rc-1.zip
yum install groovy -y
# sudo echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers
sudo mkdir -p /var/ansible/cw-misc-jenkins-agents-misc-ans
sudo yum -y install git ansible python3-pip
sudo pip3 install awscli boto3 botocore --upgrade --user
sudo pip3 install awscli boto3 botocore --upgrade --user
#export PATH=/usr/local/bin:$PATH
# install taraform 
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
## Install helm
sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo chmod 700 get_helm.sh
sudo bash get_helm.sh