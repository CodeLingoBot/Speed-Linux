#!/bin/bash
#######################################################
# btb installer
#######################################################
source btb-libs/btbSC.inc
source btb-libs/btbCC.inc
PWD=pwd

cecho "Installation start." $boldyellow
#cecho "$CPUS"  $green
#cecho "$CPUM"  $red
#cecho "$CPUC"  $red
#cecho "$CENTOSVER"  $green

if [[ "$COS7" = '7' && ! -f /usr/bin/tar ]]; then
  yum -y install tar
elif [[ "$COS8" = '8' && ! -f /bin/tar ]]; then
  yum -y install tar
fi

if [[ "$COS7" = '7' && ! -f /usr/bin/wget ]]; then
  yum -y install wget
elif [[ "$COS8" = '8' && ! -f /bin/wget ]]; then
  yum -y install tar
fi

#######################################################
source btb-libs/btbYum.inc # dnf installation
#######################################################
if [[ "$COS7" = '7' ]]; then
    echo "Check for existing mariadb packages"
    MARIADB=`rpm -qa | grep 'mariadb' | head -n1`
    if [[ ! -z "$MARIADB" ]]; then
        $RPR $MARIADB
		cecho "Removed: $MARIADB" $red
    fi
	echo "Check for existing mariadb packages"
    MARIADBSERVER=`rpm -qa | grep 'mariadb-server' | head -n1`
    if [[ ! -z "$OLDMYSQLSERVER" ]]; then
       $RPR $MARIADBSERVER
	   cecho "Removed: $MARIADBSERVER" $red
    fi
    echo "Check for existing mariadb-libs package"
    MARIADBLIBS=`rpm -qa | grep 'mariadb-libs' | head -n1`
    if [[ ! -z "$MARIADBLIBS" ]]; then
        $RPR $MARIADBLIBS
		cecho "Removed: $MARIADBLIBS" $red
    fi
    echo "Check for existing MySQL-shared-compat"
    SQLSHAREDCOMPAT=`rpm -qa | grep 'MySQL-shared-compat' | head -n1`
    if [[ ! -z "$SQSHAREDCOMPAT" ]]; then
		$RPR $SQSHAREDCOMPAT
        cecho "Removed: $SQSHAREDCOMPAT" $red
        
    fi
	echo "Check for existing MySQL-community-release"
    MYSQL=`rpm -qa | grep 'mysql80-community-rellease' | head -n1`
    if [[ ! -z "$MYSQL" ]]; then
		$RPUQ $MYSQL
		cecho "Updated: $MYSQL" $green
	else
		$RPI http://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-3.noarch.rpm
		$RPI  mysql-community-server mysql-community-client
		MYSQLS=`rpm -qa | grep 'mysql-community-server' | head -n1`
		MYSQLC=`rpm -qa | grep 'mysql-community-client' | head -n1`
        cecho "Installed: $MYSQLC & " $green
      
    fi
	
fi
echo $RPI;