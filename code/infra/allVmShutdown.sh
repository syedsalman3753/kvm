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

vmShutdown(){
  vm=$1
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "shut" ]]; then
	  echo -e "$(tput setaf 2) \n  Domain $vm Shutdown $(tput sgr0)"
	  return
 	else
  	echo -n "  "
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


echo -e "\n$(tput setaf 2)  USAGE: bash allVmShutdown.sh mosipVm.list \n"
echo "$(tput setaf 4) This script Shutdown all vm's present in specified input file $(tput sgr0)"

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

vmList=$(<$1)       # save the content of input file into a variable
userCh              # calling userch function
chkVmFile $1   # Calling chkVmFile function

virsh list --all    # list all vm's


# Shutdown all vm's
echo -n " --------- Shutdown VM's & Check its Status ";
printf '%*.0s\n' $(( $(tput cols)-45)) "" | tr " " "-"
for vm in $vmList; do
  vmShutdown $vm    # calling vmShutdown function
done

sleep 10;           # sleep for 10 seconds

# Check vm status
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  chkVmStatus $vm
done    # End of For Loop

virsh list --all

echo -e "\n$(tput setaf 2)   All VM's Successfully Shutdown !!!$(tput sgr0)";