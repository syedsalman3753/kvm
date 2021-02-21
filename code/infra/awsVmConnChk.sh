#!/usr/bin/env bash

#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) Do you want to continue ? (yes | no )$(tput sgr0) " choice;
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) AWS connection Test Operation not performed; EXITING$(tput sgr0)";
      exit 1;
    ;;
  esac
}

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
    result=$(ping -qc1 $chkVm 2>&1)
    status=$(echo $?)
    if [[ $status -eq 0 ]]; then
      echo "$(tput setaf 2)   $vm able to connect $(tput sgr0) "
      ssh -o StrictHostKeyChecking=no "$user"@$vm  "exit 0"
      return ;
    fi
    ((c++))
  done

   #When user is not able to connect vm
  echo "$(tput setaf 1) $chkVm not able to connect at $user; EXITING"
  exit 1
}


# The script starts from here

echo -e "$(tput setaf 2) \n USAGE: bash awsVmConnChk.sh hosts.ini \n";
echo "$(tput setaf 4) This script will Try to access all machines listed in specified file ";

# To check wheather all arguments are present and valid or not.
# Check mosipVm.list file present and valid or not.
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid file name; EXITING "
  exit 1
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1) File $1 not found; EXITING ";
  exit 1; 
fi

userCh  # calling userch function

# Save vmFilename & password file into a variable
awsVmNames=$( cat $1 | grep ".sb" | awk '{print $1}')           # Filter Names from given hosts.ini file
awsVmList=$awsVmNames                                     # Saving the filted AWS VM Names into a variables 
                                        
# test connectivity from host machine to $vm machine
for vm in $awsVmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  chkConn $vm "root"; # calling chkConn function
done

echo -e "$(tput setaf 2) \n AWS connection Test Operation Successfully Executed !!!$(tput sgr0)"