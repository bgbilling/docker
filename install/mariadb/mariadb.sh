#!/bin/sh -eux

echo "Checking prerequisite utilities (curl,wget)"
[ -n "`which wget`" ]
[ -n "`which curl`" ]


VERSION=$1

[ ! -d /var/lib/mysql ]
  
echo "Installing MariaDB"

if cat /etc/os-release | grep -Eq '\bDebian\b'; then

  apt-get -q -y install --no-install-recommends software-properties-common dirmngr
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
  
  if cat /etc/os-release | grep -Eq '\bstretch\b'; then
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.truenetwork.ru/mariadb/repo/$VERSION/debian stretch main'
  elsif cat /etc/os-release | grep -Eq '\bbuster\b'; then
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.truenetwork.ru/mariadb/repo/$VERSION/debian buster main'
  else
    echo "OS release not supported by script"
    exit -1;
  fi
  
  apt-get update
  apt-get -q -y install --no-install-recommends mariadb-server mariadb-client

  mkdir -p /etc/mysql/common
  curl -fsSL $URL_BASE/mysql/common.cnf -o /etc/mysql/common/common.cnf
  echo '!includedir /etc/mysql/common' >> /etc/mysql/my.cnf
  echo '' >> /etc/mysql/my.cnf

elsif cat /etc/centos-release | grep -Eq '\bCentOS\b'; then

  { \
    echo '[mariadb]'; \
    echo 'name = MariaDB'; \
    echo 'baseurl = http://yum.mariadb.org/$VERSION/centos7-amd64'; \
    echo 'gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'; \
    echo 'gpgcheck=1'; \
  } > /etc/yum.repos.d/MariaDB.repo

  yum -y install MariaDB-server MariaDB-client

  mkdir -p /etc/my.cnf.d/common
  curl -fsSL $URL_BASE/mysql/common.cnf -o /etc/my.cnf.d/common/common.cnf
  echo '!includedir /etc/my.cnf.d/common' >> /etc/my.cnf
  echo '' >> /etc/mysql/my.cnf
  
else

  echo "OS release not supported by this script"
  exit -1;

fi


systemctl stop mariadb

mkdir -p /etc/systemd/system/mariadb.service.d/
{ \
  echo '[Unit]'; \
  echo 'After=time-sync.target'; \
  echo '[Service]'; \
  echo 'LimitNOFILE=10000'; \
} > /etc/systemd/system/mariadb.service.d/limits.conf
 
systemctl restart mariadb

mysql -e "set global innodb_fast_shutdown = 0;"
