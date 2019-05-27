#######################################################
# btbYum.sh server config
#
#######################################################
echo 'btbYum.inc'
if [[ "$FORCE_IPVFOUR" != [yY] ]]; then
  ipv_forceopt=""
else
  ipv_forceopt='4'
fi
if [[ "$(uname -m)" = 'x86_64' ]]; then
  if [ ! "$(grep -w 'exclude' /etc/yum.conf)" ]; then
ex -s /etc/yum.conf << EOF
:/plugins=1/
:a
exclude=*.i386 *.i586 *.i686
.
:w
:q
EOF
  fi
fi

if [[ "$COS7" = '7' && "$DNF_ENABLE" = [yY] ]]; then
  if [[ $(rpm -q epel-release >/dev/null 2>&1; echo $?) != '0' ]]; then
    yum -y -q install epel-release
	cecho "INSTALLED: $(rpm -qa epel-release)" $green
    yum clean all -q
  fi

  if [[ "$DNF_COPR" = [yY] ]]; then
cat > "/etc/yum.repos.d/dnf-centos.repo" <<EOF
[dnf-centos]
name=Copr repo for dnf-centos owned by @rpm-software-management
baseurl=https://copr-be.cloud.fedoraproject.org/results/@rpm-software-management/dnf-centos/epel-7-\$basearch/
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/@rpm-software-management/dnf-centos/pubkey.gpg
enabled=1
enabled_metadata=1
EOF
  fi
  if [[ ! -f /usr/bin/dnf ]]; then
    yum -y -q  install dnf
	cecho "INSTALLED: $(rpm -qa dnf)" $green
    dnf clean all -q
  fi
  if [ ! "$(grep -w 'exclude' /etc/dnf/dnf.conf)" ]; then
    echo "excludepkgs=*.i386 *.i586 *.i686" >> /etc/dnf/dnf.conf
  fi
  if [ ! "$(grep -w 'fastestmirror=true' /etc/dnf/dnf.conf)" ]; then
    echo "fastestmirror=true" >> /etc/dnf/dnf.conf
  fi
  if [ -f /etc/yum.repos.d/rpmforge.repo ]; then
      sed -i 's|enabled .*|enabled = 0|g' /etc/yum.repos.d/rpmforge.repo
      DISABLEREPO_DNF=' --disablerepo=rpmforge'
      YUMDNFBIN="dnf${DISABLEREPO_DNF}"
  else
      DISABLEREPO_DNF=""
      YUMDNFBIN='dnf'
  fi
else
  YUMDNFBIN='yum'
  if [ -f /etc/yum.repos.d/rpmforge.repo ]; then
    DISABLEREPO_DNF=' --disablerepo=rpmforge'
  else
    DISABLEREPO_DNF=""
  fi
fi

if [[ "$DNF_ENABLE" = [yY] ]]; then
	RPI='dnf -y install'
	RPIQ='dnf -y -q install'
	RPR='dnf -y remove'
	RPRQ='dnf -y -q remove'
	RPU='dnf -y update'
	RPUQ='dnf -y -q update'
else
	RPI='yum -y install'
	RPIQ='yum -y -q install'
	RPR='yum -y remove'
	RPRQ='yum -y -q remove'
	RPU='yum -y update'
	RPUQ='yum -y -q update'
fi