#!/usr/bin/env bash

# this function will shutdown the vm
vmShutdown(){
  vm=$1
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "shut" ]]; then
	  echo -e "$(tput setaf 2)\n\t Domain $vm Shutdown $(tput sgr0)"
	  return
 	else
    echo -en "\n\t "
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
    echo -e "$(tput setaf 3)\t Trying to Get Status for $chkVm machine : $(tput sgr0)  $vmStatus $c ";

    # To check user connectivity with vm's.
    result=$(ping -qc1 $chkVm 2>&1)
    status=$(echo $?)
    if [[ $status -gt 0 ]]; then
      echo -e "$(tput setaf 2)\t $chkVm machine is now Shutdown $(tput sgr0) "
      return ;
    fi
    ((c++))
    sleep 2
  done

  # When user is not able to connect vm
  echo "$(tput setaf 1) Unable Shutdown $chkVm machine; EXITING  $(tput sgr0)"
  exit 1
}

# To undefine a machine
vmUndefine(){
  vm=$1
  errCount=$(virsh dumpxml $vm 2>&1 | wc -l)
  
  echo -e "\n"
  if [[ $errCount -eq 2  ]]; then
  		echo -e "$(tput setaf 2)\t $vm machine is already undefined  $(tput sgr0)";
  		return
  else 
    	echo -ne "\t "
    	tput setaf 10
    	virsh undefine $vmName
    	tput sgr0		
  fi
}

# Remove snapshots from vm's
rmSnpshot(){
    echo -e ""
	vm=$1
	snpShtList=$(virsh snapshot-list  $vm  | awk 'NR>2{print $1}')
	
	snpShtListCount=$( echo $snpShtList | wc -w )
	if [[ $snpShtListCount -eq 0 ]]; then
		echo -e "$(tput setaf 5)\t No Snapshots found; Skipping $(tput sgr0)";
		return
	fi 
    
    for snpName in $snpShtList; do
    	echo -ne "\t "
   		tput setaf 10
    	virsh snapshot-delete $vmName $snpName
    	tput sgr0	
    done
}

# To remove vm's qcow2 image file 
rmQcow2File(){
	vm=$1
 	vmPool=$2
 	vmImgPath=$(virsh vol-list --pool $vmPool 2>&1 | grep -w $vm | awk '{print $2}')

 	if ! [[ -f $vmImgPath ]]; then
 		echo -e "$(tput setaf 5)\n\t $vm machine qcow2 image path not found; Skipping";
 		return
 	fi
    echo -ne "\n\t "
    tput setaf 10
    virsh vol-delete "$vm.qcow2" --pool $vmPool
    tput sgr0 
    return
}

# The script starts from Here
echo -e "\n$(tput setaf 2)  USAGE: bash vmRemove.sh vmName vmPoolName \n $(tput sgr0)"
if [ "$#" -eq 0 ]; then
	echo "$(tput setaf 1) VM name not provided; Exiting;$(tput sgr0)"
	exit 1
elif [ "$#" -gt 2 ]; then
	echo "$(tput setaf 1) only one Argument is Allowed; Exiting; $(tput sgr0)"
	exit 1
elif [[ "$2" == "" ]]; then
	echo "$(tput setaf 1) VM Pool Name not provided; Exiting;$(tput sgr0)"
	exit 1
fi

vmName=$1
poolName=$2

read -p "$(tput setaf 3) Are you sure you want to forever destroy $vmName? $(tput sgr0)" -n 1 -r
echo    # (optional) move to a new line

if ! [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "$(tput setaf 1) VM Remove operation not performed; EXITING; $(tput sgr0)";
    exit 1
else
	errCount=$(virsh desc $vmName 2>&1 | grep error | wc -l)
	if [[ $errCount -eq 1 ]]; then
		echo -e "$(tput setaf 1) $vmName machine doesn't Exist; EXITING; $(tput sgr0)"
		exit 1
	fi
fi

echo -e "\n$(tput setaf 6) [$vmName] $(tput sgr 0)"

# shutdown machine
echo -n "$(tput setaf 9)    [shutdown-Machine] $(tput sgr 0)"
vmShutdown $vmName          		# calling vmShutdown function 
chkVmStatus $vmName        	 		# calling vmStatus function

# Remove snapshots for vm
echo -n "$(tput setaf 9)    [Remove-Snapshots] $(tput sgr 0)"
rmSnpshot $vmName

# Remove vm qcow2 image
echo -n "$(tput setaf 9)    [Remove-qcow2 image] $(tput sgr 0)"
 rmQcow2File $vmName $poolName       # calling rmQcow2File function

# undefine vm 
 echo -n "$(tput setaf 9)    [Undefine $vm] $(tput sgr 0)"
 vmUndefine $vmName                	# calling vmUndefine function