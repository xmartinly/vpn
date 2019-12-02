#!/bin/bash
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y yum-utils && yum-config-manager --enable epel
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum clean all && yum makecache fast && yum update -y
yum install docker-ce zip unzip curl wget git -y
systemctl enable docker.service && systemctl start docker.service

#usermod -aG docker xmartinly

systemctl enable firewalld && systemctl restart firewalld
firewall-cmd --permanent --add-port=38531-38536/tcp
firewall-cmd --permanent --add-port=1701/tcp
firewall-cmd --permanent --add-port=38531-38536/udp
firewall-cmd --permanent --add-port=500/udp
firewall-cmd --permanent --add-port=4500/udp
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=postgresql
firewall-cmd --reload

mkdir -p /home/container && cd /home/container
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

mkdir -p /home/container && cd /home/container
git clone https://github.com/xmartinly/vpn.git
cd vpn
docker-compose up -d
