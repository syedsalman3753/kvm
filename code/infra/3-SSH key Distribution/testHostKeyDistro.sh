#!/usr/bin/env bash

#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) Do you want to continue ? (yes | no ) $(tput sgr0)" choice
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) Test Host Key Distribution operation not performed; EXITING $(tput sgr0)";
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
    if [ "$vm" == "" ]; then
      echo "$(tput setaf 1) Here there is no vm's list; EXITING "
      exit 1;
    elif ! [[ "$vm" =~ ^[a-zA-Z0-9_.]+$ ]]; then
      echo "$(tput setaf 1) $vm is not a valid virtual machine name; EXITING"
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


#Check wheather user is able to connect vm or not...
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
      return
    fi
    ((c++))
  done

    # When user is not able to connect vm
    echo "$(tput setaf 1) $chkVm not able to connect at $user; EXITING $(tput sgr0)"
    exit 1
}

# Check the status of ssh public key From host machine to all vm's
testHostKeyDistro() {
  host=$1
  vm=$2
  usr=$3
  ssh_exit_status=0
  ssh_exit_status=$(echo $?)   # exit status
  ssh_out=$(ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=publickey $usr@$vm "exit 0" 2>&1) ;
  ssh_ext=$(echo $?);

  # check if error is due to Permission denied or not
  ssh_err_chk=$(echo $ssh_out | grep "Permission denied" | wc -l)
  if [ $ssh_err_chk -eq 1 ]; then
    echo "$(tput setaf 1) From $host machine to $usr@$vm machine Key Distribution Test Operation Failed; EXITING$(tput sgr0)";
    exit 1;
  fi
  echo "  $(tput setaf 2) $vm ---> $usr"
  return 0
}

## The script starts from here
echo -e "$(tput setaf 2) \n USAGE: bash testHostKeyDistro2.sh mosipVm.list \n"
echo "$(tput setaf 4) This script perform host machine is able to login to all vm's without password $(tput sgr0)"

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

# calling userCh function which will ask you whether they want to continue or not
userCh  # calling userCh function

# save the content of the file mosipVm.list in a variable
vmList=$(<$1)
chkVmFile $1     # calling checkVmFile function

# Iterate through input file, check existence and connectivity :
echo
echo -n " ---------- VM connectivity test "; printf '%*.0s\n' $(( $(tput cols)-33)) "" | tr " " "-"
for vm in $vmList; do
  # start vm's 
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
  if [[ "$status" == "running" ]]; then
   echo "$(tput setaf 2) Domain $vm Running$(tput sgr0)"
  else
    tput setaf 10;
    echo -n " "
    virsh start $vm;
    tput sgr0;
  fi
done

# test connectivity from trex to $vm machine
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  chkConn $vm "mosipuser"  # calling chkConn function for mosipuser
  chkConn $vm "root"  # calling chkConn function for root user
done

host=$(echo $HOSTNAME)
echo
echo -n " ----------Test Host Key Distribution "; printf '%*.0s' $(( $(tput cols)-38)) "" | tr " " "-"

# Iterate thru input file and check existence:
for vm in $vmList; do
  tput setaf 6   # to set color in terminal
  echo " [ $vm ] " ;
  # printf '%*.0s' $(( $(tput cols)-${#vm}-5)) "" | tr " " "-"
  tput sgr0      # reset color in terminal

  testHostKeyDistro $host $vm  "mosipuser"      # calling  MkAndChkFile function and passing host machine and vm
  testHostKeyDistro $host $vm  "root"      # calling  MkAndChkFile function and passing host machine and vm
done
echo -e "$(tput setaf 2) \n Host Key Distribution test Successfully executed !!!$(tput sgr0)";