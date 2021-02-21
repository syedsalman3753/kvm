#!/usr/bin/env bash


vmShutdown(){
  vm=$1
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "shut" ]]; then
	  echo -e "$(tput setaf 2) \n  Domain $vm Shutdown $(tput sgr0)"
	  return
 	else
  	echo -n "\t"
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
    echo "$(tput setaf 3)   Trying to Get Status for $chkVm machine : $(tput sgr0)  $vmStatus $c ";

    # To check user connectivity with vm's.
    result=$(ping -qc1 $chkVm)
    status=$(echo $?)
    if [[ $status -gt 0 ]]; then
      echo -e "$(tput setaf 2)   $chkVm machine is now Shutdown $(tput sgr0) "
      return ;
    fi
    ((c++))
    sleep 2
  done

  # When user is not able to connect vm
  echo "$(tput setaf 1) Unable Shutdown $chkVm machine ; EXITING"
  exit 1
}


# The script starts from Here
echo -e "\n$(tput setaf 2)  USAGE: bash vmRemove.sh vmName \n $(tput sgr0)"
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

read -p "$(tput setaf 3) Are you sure you want to forever destroy $vmName? $(tput sgr0)" -n 1 -r
echo    # (optional) move to a new line

if ! [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "$(tput setaf 1) VM Remove operation not performed; EXITING; $(tput sgr0)";
    exit 1
else
	errCount=$(virsh desc $vmName 2>&1 | grep error | wc -l)
	if [[ $errCount -eq 1 ]]; then
		echo "$(tput setaf 1) $vmName machine doesn't Exist; Exiting; $(tput sgr0)"
		exit 1
	fi
fi

vmShutdown $vmName          # calling vmShutdown function 
chkVmStatus $vmName         # calling vmStatus function

# virsh undefine $vmName
# virsh vol-delete $vmName.qcow2 --pool default