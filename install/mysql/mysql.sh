#!/bin/sh -eux

URL=https://raw.githubusercontent.com/bgbilling
URL_BASE=$URL/images-base/master/install


echo "Checking prerequisite utilities (curl,wget)"
[ -n "`which wget`" ]
[ -n "`which curl`" ]


[ ! -d /var/lib/mysql ]
  
echo "Installing MySQL"

mysql=mysql

if cat /etc/os-release | grep -Eq '\bDebian\b'; then

  export DEBIAN_FRONTEND=noninteractive

  echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
  echo "mysql-server mysql-server/root-pass password ''" | debconf-set-selections
  echo "mysql-server mysql-server/re-root-pass password ''" | debconf-set-selections
  echo "mysql-server mysql-server/data-dir select ''" | debconf-set-selections

  curl -fsSL https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb -o mysql-apt-config_0.8.9-1_all.deb
  dpkg -i mysql-apt-config*

  apt-get update && apt-get install -y mysql-server mysql-client
  rm mysql-apt-config*
  
  if [ -f /lib/systemd/system/mysqld.service ]; then mysql=mysqld; fi

  systemctl stop $mysql
  if [ -f /etc/init.d/mysql ]; then mv /etc/init.d/mysql /var/tmp; fi
  systemctl disable $mysql
  systemctl enable $mysql

  mkdir -p /etc/mysql/common
  curl -fsSL $URL_BASE/mysql/common.cnf -o /etc/mysql/common/common.cnf
  echo '!includedir /etc/mysql/common' >> /etc/mysql/my.cnf
  echo '' >> /etc/mysql/my.cnf

elif cat /etc/centos-release | grep -Eq '\bCentOS\b'; then

  wget http://repo.mysql.com/mysql57-community-release-el7.rpm
  #yum localinstall mysql57-community-release-el7-7.noarch.rpm
  #yum repolist enabled | grep "mysql.*-community.*
  rpm -ivh mysql57-community-release-el7.rpm
  rm mysql57-community-release-el7.rpm
  yum update -y
  yum install -y mysql-server mysql-client

  if [ -f /lib/systemd/system/mysqld.service ]; then mysql=mysqld; fi

  systemctl stop $mysql
  if [ -f /etc/init.d/mysql ]; then mv /etc/init.d/mysql /var/tmp; fi
  systemctl disable $mysql
  systemctl enable $mysql

  curl -fsSL $URL_BASE/mysql/common.cnf -o /etc/my.cnf.d/common.cnf
  echo '!includedir /etc/my.cnf.d' >> /etc/my.cnf
  echo '' >> /etc/my.cnf
  
  systemctl stop $mysql;
  rm -f /var/lib/mysql/*
  sudo -umysql mysqld --initialize-insecure
  
else

  echo "OS release not supported by this script"
  exit -1;

fi


mkdir -p /etc/systemd/system/${mysql}.service.d/
{ \
  echo '[Unit]'; \
  echo 'After=time-sync.target'; \
  echo '[Service]'; \
  echo 'LimitNOFILE=10000'; \
} > /etc/systemd/system/${mysql}.service.d/limits.conf
 
systemctl daemon-reload
systemctl restart $mysql

mysql -e "set global innodb_fast_shutdown = 0;"
