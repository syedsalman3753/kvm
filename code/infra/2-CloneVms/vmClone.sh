#!/usr/bin/env bash

# this function will shutdown the vm
vmShutdown(){
  vm=$1
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "shut" ]]; then
	  echo -e "$(tput setaf 2)\n\tDomain $vm Shutdown $(tput sgr0)"
	  return
 	else
    echo -en "\n\t"
    tput setaf 10
    virsh shutdown $vm;
    tput sgr0
 	fi
}

# check vm connectivity
chkVmStatus() {
  chkVm=$1
  c=0
  while [ $c -lt 10 ]; do
    vmStatus=$(virsh list --all | grep -w "$vm" | awk '{print $3$4}')
    echo -e "$(tput setaf 3)\tTrying to Get Status for $chkVm machine : $(tput sgr0)  $vmStatus $c ";

    # To check user connectivity with vm's.
    result=$(ping -qc1 $chkVm 2>&1)
    status=$(echo $?)
    if [[ $status -gt 0 ]]; then
      echo -e "$(tput setaf 2)\t$chkVm machine is now Shutdown $(tput sgr0) "
      return ;
    fi
    ((c++))
    sleep 2
  done

  # When user is not able to connect vm
  echo "$(tput setaf 1) Unable Shutdown $chkVm machine; EXITING  $(tput sgr0)"
  exit 1
}


# The script starts from Here
if [ "$#" -ne 2 ]; then
	echo " Destination and Source VM names (exactly TWO params, in that order) must be provided"
	exit 1
fi

destVm=$1
srcVm=$2

read -p " Are you sure you want to clone $destVm from $srcVm? " -n 1 -r
echo    # (optional) move to a new line

if ! [[ $REPLY =~ ^[Yy]$ ]]; then
    echo " Vm Clone operation not performed; EXITING;";
    exit 1
fi

# shutdown machine
echo -n "$(tput setaf 9) [shutdown-Machine] $(tput sgr 0)"
vmShutdown $srcVm          		    # calling vmShutdown function 
chkVmStatus $srcVm        	 		# calling vmStatus function

sleep 10

echo -n "$(tput setaf 9) [clone-Machine] $(tput sgr 0)"
echo -e "\n Clone $destVm from $srcVm"
sudo virt-clone --connect qemu:///system  --original $srcVm  --name $destVm  --auto-clone
	
echo Correct the host name
sudo virt-customize -d $destVm --hostname $destVm
		
echo Cleanup logs etc
sudo virt-sysprep -d $destVm \
		--enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
	
virsh desc $destVm Cloned from $srcVm
virsh desc $destVm --title $destVm 
