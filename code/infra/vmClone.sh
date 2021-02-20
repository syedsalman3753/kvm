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

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo Clone $destVm from $srcVm
	sudo virt-clone --connect qemu:///system  --original $srcVm  --name $destVm  --auto-clone
	
	echo Correct the host name
	sudo virt-customize -d $destVm --hostname $destVm
	
	#check for VM host key in VM:~/.ssh/authorized_keys
	#hostKeyVal=$(cat ~/.ssh/id_rsa.pub)
	#vmHasId=$(sudo virt-cat -d $destVm /home/kvmuser/.ssh/authorized_keys)
	#if [ $vmHasId -lt 1 ]; then
		#echo Put host public key in guest .ssh/authorized_keys
		#sudo virt-customize -d $destVm --ssh-inject kvmuser:file:/home/anadi/.ssh/id_rsa.pub
	#fi
	
	echo Cleanup logs etc
	sudo virt-sysprep -d $destVm \
		--enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
	
	virsh desc $destVm Cloned from $srcVm
	virsh desc $destVm --title $destVm 
	
	#Check if vmhost is already in the hosts file, if not, add it:
	hasVmHostSet=$(sudo virt-cat -d nseCollectVm /etc/hosts |grep 192.168.122.1|grep vmhost|wc -l)
	#if [ $hasVmHost -eq 0 ]; then
		#echo "vmhost not added, Now add it in /etc/hosts"
		#sudo  virt-customize -d $destVm --run-command "echo -e '192.168.122.1\\tvmhost'"
	#fi
	
	#TODO: consider making a change in the fstab to mount the host NFS drive.
else
	echo Exiting without doing any real work!
fi
