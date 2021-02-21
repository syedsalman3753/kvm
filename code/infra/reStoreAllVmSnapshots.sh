#!/bin/bash

userCh(){
  read -p "$(tput setaf 3) Do you wants to continue ? (yes | no ) $(tput sgr0) " choice
  case $choice in
   	Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) VM SnapShorts Restore Operation not performed; EXITING $(tput sgr0) ";
      exit 1;
    ;;
  esac
}
# Check VM Existence, if VM does not exist then report and exit. use "virsh desc $VM" to check the existence.
# Check filename and wheather all vm names are valid or not.
chkVmFile(){
  # saving the content of a file into a variable 'file'.
  file=$(<$1);

  #Iterate through input file and check for vm valid names and also their exisitence:
  for vm in $file; do
    if [ "$vm" == "" ]; then
      echo "$(tput setaf 1) Here there is no vm's list; EXITING "
      exit 1;
    elif ! [[ "$vm" =~ ^[a-zA-Z0-9_.]+$ ]]; then
      echo "$(tput setaf 1) $vm is not a valid virtual machine name; EXITING"
      exit 1;
    fi

    # check existence of vm
    res=$(virsh desc $vm)
    if [ "$res" == "" ]; then
      echo "$(tput setaf 1) $vm machine does not exists; EXITING";
      exit 1;
    fi
  done
}
# start vms
vmStart(){
  vm=$1
 	status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "running" ]]; then
	  echo -e "$(tput setaf 2) \n  Domain $vm Running$(tput sgr0)"
 	else
  	echo -n "  "
    tput setaf 10
    virsh start $vm;
    tput sgr0
 	fi
}

# check vm connectivity
chkConn() {
  chkVm=$1
  user=$2
  c=0
  while [ $c -lt 10 ]; do
    echo "$(tput setaf 3)   Trying to connect $user@$chkVm : $(tput sgr0)  $c";

    # To check user connectivity with vm's.
    result=$(ping -qc1 $chkVm)
    status=$(echo $?)
    if [[ $status -eq 0 ]]; then
      echo "$(tput setaf 2)   $vm able to connect $(tput sgr0) "
      ssh -o StrictHostKeyChecking=no "$user"@$vm  "exit 0"
      return ;
    fi
    ((c++))
  done

  # When user is not able to connect vm
  echo "$(tput setaf 1) $chkVm not able to connect at $user; EXITING"
  exit 1
}

# The script start from here

# if mosipVm.list is not available? add validation. Read the vmList as input parameter to the list
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING $(tput sgr0) ";
  exit 1;
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1) File $1 not found; EXITING $(tput sgr0) ";
  exit 1;
fi

# check if chkpt is a valid linux filename: https://stackoverflow.com/questions/18282929/how-to-validate-filename-in-bash-script
if [[  $2 == "" ]]; then
  echo "$(tput setaf 1) chkpoint file name not provided; EXITING$(tput sgr0) ";
  exit 1;
elif ! [[ $2 =~ ^[0-9a-zA-Z._-]+$ ]]; then
  echo "$(tput setaf 1) '$2' is not a valid file name; EXITING$(tput sgr0) "
  exit 1
fi


# script starts from here
echo -e "\n$(tput setaf 2)  USAGE: bash RestoreAllVm.sh vmlistFilename chkpt_name\n $(tput sgr0)";
echo "$(tput setaf 4) This script will Restore all VM's listed in specified input file using Snapshots $(tput sgr0)";

userCh             # calling userCh function
chkVmFile $1       # calling checkVmFile function
vmList=$(<$1);     # save the contents of (mosipVm.list) input file
chkpt=$2           # Check point

# start all vm's
echo -n " --------- Start VM's & Test its Connectivity ";
printf '%*.0s\n' $(( $(tput cols)-48)) "" | tr " " "-"
for vm in $vmList; do
  vmStart $vm
done
sleep 10
# test connectivity from trex to $vm machine
for vm in $vmList; do
	echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
	chkConn $vm  "root" # calling chkConn function
	chkConn $vm  "mosipuser" # calling chkConn function
done


# Restore vm's from Backup
echo -n " --------- Restore from SnapShorts ";
printf '%*.0s\n' $(( $(tput cols)-36)) "" | tr " " "-"
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
	snap_res=$( virsh snapshot-list $vm | grep -w "$vm-$chkpt.kvmSnpSht" | wc -l)
	if [ $snap_res -eq 0 ]; then
		echo "$(tput setaf 6)   $vm-$chkpt.kvmSnpSht Snapshot not found; SKIPPING"
		continue ;
	fi
	virsh snapshot-revert $vm "$vm-$chkpt.kvmSnpSht"
	echo "$(tput setaf 3)   Successfully Restored $vm from  $vm-$chkpt.kvmSnpSht Snapshot $(tput sgr0)"
done

echo -e "\n$(tput setaf 2) All vm's successfully restored !!! $(tput sgr0)"