#!/usr/bin/env bash

set +x
set -e

destVm=$1

srcVm=$2

echo "If you already have a baseVm and only want to do incremental enhancement"
echo "Consider using vmClone.sh, its much light weight"

echo "USE THIS SCRIPT FOR STANDARDIZING basePyVm from a anmolvm-1 copy"
read -p "Continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo OK
else
	echo Exiting without doing any real work!
	exit 1
fi

if [ "$#" -ne 2 ]; then
	echo "source and destination VM names (exactly TWO params) must be provided"
	exit 1
fi

read -p "Are you sure you want to clone $destVm from $srcVm? " -n 1 -r
echo    # (optional) move to a new line

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo Clone $destVm from $srcVm
	sudo virt-clone --connect qemu:///system  --original $srcVm  --name $destVm  --auto-clone
	
	echo Set root password
	sudo virt-customize -d $destVm --root-password password:root
	
	echo Remove user account anadi
	sudo virt-sysprep -d $destVm --enable user-account
	#now anadi account will be lost
	#This removes the anadi group too.
	
	echo Create kvmuser account, password: kvm
	sudo virt-customize -d $destVm --run-command "sudo useradd -s /bin/bash -m -G sudo kvmuser"
	# Execute chage -d 0 kvmuser if you want kvmuser to change password upon first login
	
	echo Set kvmuser account password to: kvm
	sudo virt-customize -d $destVm --password kvmuser:password:kvm
	
	echo Lock root account
	sudo virt-customize -d $destVm --run-command "sudo passwd -dl root"
	
	echo Correct the host name
	sudo virt-customize -d $destVm --hostname $destVm
	
	echo Adding kvmuser to groups
	sudo virt-customize -d $destVm --run-command "sudo adduser kvmuser adm; sudo adduser kvmuser cdrom; sudo adduser kvmuser dip"
	sudo virt-customize -d $destVm --run-command "sudo adduser kvmuser plugdev; sudo adduser kvmuser lpadmin; sudo adduser kvmuser sambashare"
	
	echo Adding kvmuser to sudoers
	sudo virt-customize -d $destVm --run-command "sudo echo 'kvmuser ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"
	
	#check for VM host key in VM:~/.ssh/authorized_keys
	hostKeyVal=$(cat ~/.ssh/id_rsa.pub)
	vmHasId=$(sudo virt-cat -d $destVm /home/kvmuser/.ssh/authorized_keys)
	if [ $vmHasId -lt 1 ]; then
		echo Put host public key in guest .ssh/authorized_keys
		sudo virt-customize -d $destVm --ssh-inject kvmuser:file:/home/anadi/.ssh/id_rsa.pub
	fi
	
	echo put am bash and git cuts into the guest, setup PS1 variable
	sudo virt-copy-in -d $destVm /home/anadi/.am-bash-cuts.sh /home/kvmuser/
	sudo virt-copy-in -d $destVm /home/anadi/.am-git-cuts.sh /home/kvmuser/
	sudo virt-customize -d $destVm --run-command "printf '\n#Adding anadi shortcuts\n' >> /home/kvmuser/.bashrc"
	sudo virt-customize -d $destVm --run-command "echo 'source ~/.am-bash-cuts.sh' >> /home/kvmuser/.bashrc"
	sudo virt-customize -d $destVm --run-command "echo 'source ~/.am-git-cuts.sh' >> /home/kvmuser/.bashrc"
	echo Enable color prompt in bashrc file
	sudo virt-customize -d $destVm --run-command "sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/kvmuser/.bashrc"
	#echo setup anadi style prompt NOT ABLE TO GET CORRECT SEARCH STRING.
	#sudo virt-customize -d $destVm --run-command "sed -i 's/\\\$\s\'$/\n\$ \'/g' /home/kvmuser/.bashrc"
	echo FOR NOW SET PS1 by editing .bashrc
	
	echo Cleanup logs etc
	sudo virt-sysprep -d $destVm \
		--enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
	
	virsh desc $destVm Cloned from $srcVm
	virsh desc $destVm --title $destVm
	
	#Check if vmhost is already in the hosts file, if not, add it:
	hasVmHostSet=$(sudo virt-cat -d $destVm /etc/hosts |grep 192.168.122.1|grep vmhost|wc -l)
	if [ $hasVmHost -eq 0 ]; then
		echo "Now setup vmhost in /etc/hosts"
		sudo  virt-customize -d $destVm --run-command "echo -e '192.168.122.1\\tvmhost'"
	fi
	
	#TODO: consider making a change in the fstab to mount the host NFS drive.
else
	echo Exiting without doing any real work!
fi