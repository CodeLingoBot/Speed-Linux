#!/bin/bash
# ╭――╮
# SPOS ─ text graphic interface.
# ╰──╯	 SPOS - basic-info-graph.inc
#	├──▶ Start required config.
#	╰──▶ First server config file.
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
source SpeedLIB/required-details-graph.inc # dnf installation
#######################################################

