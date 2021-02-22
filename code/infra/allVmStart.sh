#!/bin/bash


#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3 ) Do you want to continue ? (yes | no ) $(tput sgr0)" choice
  case $choice in
  	 Yes|yes|y|Y)
     	echo "";
     ;;
     *)
        echo "$(tput setaf 1) Vm's Start operation Not Performed; EXITING $(tput sgr0)";
        exit 1;
      ;;
  esac
}

# Check VM Existence, if VM does not exist then report and exit. use "virsh desc $VM" to check the existence.
# Check filename and wheather all vm names are valid or not.
chkVmFile(){
  # saving the content of a file into a variable 'file'.
  file=$(<$1);

  # Iterate through input file and check for vm valid names and also their exisitence:
  for vm in $file; do
    # check vm names
    if [ "$vm" == "" ]; then
      echo "$(tput setaf 1) No VM's present in the List; EXITING$(tput sgr0)";
      exit 1;
    elif ! [[ "$vm" =~ ^[a-zA-Z0-9_.]+$ ]]; then
      echo "$(tput setaf)$vm is not a valid virtual machine name; EXITING $(tput sgr0)";
      exit 1;
    fi

    # check existence of vm
    res=$(virsh desc $vm  2>&1 | grep error | wc -l )
    if [[ $res -eq 1 ]]; then
      echo "$(tput setaf 1) $vm machine does not exists; EXITING $(tput sgr0)";
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

echo -e "\n$(tput setaf 2)  USAGE: bash allVmStart.sh mosipVm.list \n"
echo "$(tput setaf 4) This script start vm's present in specified input file $(tput sgr0)"

#To check wheather all arguments are present and valid or not.
#Check mosipVm.list file present and valid or not.
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING$(tput sgr0)";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid file name; EXITING $(tput sgr0)"
  exit 1
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1) File $1 not found; EXITING $(tput sgr0)";
  exit 1;
fi

vmList=$(<$1)
userCh               # calling userch function
chkVmFile $1         # calling chkVmFile function
virsh list --all

# start all vm's
echo -n " --------- Start VM's & Test its Connectivity ";
printf '%*.0s\n' $(( $(tput cols)-50)) "" | tr " " "-"
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

echo -e "\n$(tput setaf 2)  Successfully Started All VM's $(tput sgr0)";