#!/usr/bin/env bash

set +x
set -e

destVm=$1
srcVm=$2

if [ "$#" -ne 2 ]; then
	echo "Destination and Source VM names (exactly TWO params, in that order) must be provided"
	exit 1
fi

read -p "Are you sure you want to clone $destVm from $srcVm? " -n 1 -r
echo    # (optional) move to a new line

if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Vm Clone operation not performed; EXITING;";
fi

echo Clone $destVm from $srcVm
sudo virt-clone --connect qemu:///system  --original $srcVm  --name $destVm  --auto-clone
	
echo Correct the host name
sudo virt-customize -d $destVm --hostname $destVm
		
echo Cleanup logs etc
sudo virt-sysprep -d $destVm \
		--enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
	
virsh desc $destVm Cloned from $srcVm
virsh desc $destVm --title $destVm 

