#!/usr/bin/env bash

#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) Do you want to continue ? (yes | no )$(tput sgr0) " choice;
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) Host Key Distribution operation not performed; EXITING$(tput sgr0)";
      exit 1;
    ;;
  esac
}

#This function is to prompt wheather sshpass is installed or not!!!!
chksshPass(){
  chkSSHpass=$(sshpass 2>&1)
  count=$(echo $chkSSHpass | grep "password" | wc -l)
  if [[ $count -eq 0 ]]; then
    echo -e "$(tput setaf 1) sshpass is not installed; EXITING $(tput sgr0)";
    echo -e "$(tput setaf 4) \n To install sshpass execute the following command $(tput sgr0)";
	  echo -e "$(tput setaf 2) \n USAGE:  sudo apt-get install sshpass -y \n $(tput sgr0)";
    exit 1;
  else
	  return
  fi
}

# Check VM Existence VM1 does not exist - report and exit (do a virsh desc VM) checkVm(VM1)
# filename and chk valid all vm names
chkVmFile(){
  # save content of a file into a variable
  file=$(<$1);
  # # Iterate thru input file and check for vm valid names and also their exisitence:
  for vm in $file; do
  	if [ "$vm" == "" ]; then
  		echo "$(tput setaf 1) No vm's present; EXITING $(tput sgr0) "
  		exit 1;
  	elif ! [[ "$vm" =~ ^[a-zA-Z0-9_.]+$ ]]; then
    	echo "$(tput setaf 1) $vm is not a valid virtual machine name; EXITING$(tput sgr0) "
    	exit 1
	  fi

    # check existence of vm
    res=$(virsh desc $vm  2>&1 | grep error | wc -l )
    if [[ $res -eq 1 ]]; then
      echo "$(tput setaf 1) $vm machine does not exists; EXITING $(tput sgr0)";
      exit 1;
    fi
  done
}
# check vm connectivity
chkConn() {
  chkVm=$1
  user=$2
  c=0
  while [ $c -lt 10 ]; do
    echo "$(tput setaf 3)   Trying to connect $user@$chkVm : $(tput sgr0)  $c";

    #To check user connectivity with vm's.
    result=$(ping -qc1 $chkVm)
    status=$(echo $?)
    if [[ $status -eq 0 ]]; then
      echo "$(tput setaf 2)   $vm able to connect $(tput sgr0) "
      sshpass -p "$passwd" ssh -o StrictHostKeyChecking=no "$user"@$vm  "exit 0"
      return ;
    fi
    ((c++))
  done

   #When user is not able to connect vm
  echo "$(tput setaf 1) $chkVm not able to connect at $user; EXITING"
  exit 1
}
