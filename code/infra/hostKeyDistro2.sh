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

# The script starts from here

echo -e "$(tput setaf 2) \n USAGE: bash hostkeyDistro2.sh mosipVm.list passwd.txt \n";
echo "$(tput setaf 4) This script will make Host machine passwordLess access to all vm's listed in mosipVm.list file ";

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

# check password file is provided or not and valid or not.
elif [[  $2 == "" ]]; then
  echo "$(tput setaf 1) Password File is not provided; EXITING";
  exit 1;
elif ! [[ $2 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $2 is not a valid file name; EXITING "
  exit 1
elif [[ ! -f $2 ]]; then
  echo "$(tput setaf 1) File $2 not found; EXITING ";
  exit 1;

# check ssh-copy-id is installed on host machine
elif [[ ! -f "/usr/bin/ssh-copy-id" ]]; then
  echo "$(tput setaf 1) ssh-copy-id not Installed; EXITING ";
  exit 1;
fi

# Save vmFilename & password file into a variable
vmList=$(<$1)
passwd=$(<$2)

# calling userCh function which will ask you whether they want to continue or not
userCh  			# calling userCh function
chksshPass			# calling sshPass function
chkVmFile $1   		# calling checkVmFile function

# listing status of all vm's
virsh list --all

# starting vm's if they are shutdown
echo -n " --------- VM connectivity test ";
printf '%*.0s\n' $(( $(tput cols)-32)) "" | tr " " "-"

for vm in $vmList; do
  vmRunning=$(virsh list | grep -w $vm | wc -l)
  if [[ $vmRunning -eq "0" ]]; then
    echo -n "  "
    tput setaf 10
    virsh start $vm;
    tput sgr0
  else
    echo -e "$(tput setaf 2) \n  Domain $vm Running$(tput sgr0)"
  fi
done

# test connectivity from host machine to $vm machine
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  chkConn $vm "mosipuser";			# calling chkConn function
  chkConn $vm "root"; 				# calling chkConn function
done

# To add host ssh keys fro both mosipuser & root user
echo -e "\n"
echo -n " ---------- ADD SSH Key To The Machine ";
printf '%*.0s' $(( $(tput cols)-40)) "" | tr " " "-"; echo -e "\n";



# copy HOST machine ssh public key to host machines ~/.ssh/authorized_keys file
echo -e "\n $(tput setaf 6)[ $HOSTNAME ] $(tput sgr0)";
ssh-copy-id -o StrictHostKeyChecking=no $USER@$HOSTNAME


# make ssh passwordLess from host to vm's
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  for user in root mosipuser; do
    ssh_out=$( sshpass -p "$passwd" ssh-copy-id -o StrictHostKeyChecking=no $user@$vm 2>&1 | grep "Number of key(s) added:" | wc -l )
    if [[ $ssh_out -eq 0 ]]; then
    	# If file is already existed show existance.
 		echo "$(tput setaf 2)   $3 machine ssh key already present in $vm for user ---> $user!! $(tput sgr0) ";
 		continue
    fi
    # if new key is inserted
    echo "$(tput setaf 3)   $3 machine ssh key inserted in $vm machine for user --> $!! $(tput sgr0) ";
  done
done   