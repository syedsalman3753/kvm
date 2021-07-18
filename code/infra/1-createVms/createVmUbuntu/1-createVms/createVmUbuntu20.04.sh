#!/usr/bin/env bash
# Source https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html#toc_5


#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) Do you want to continue ? (yes | no )$(tput sgr0) " choice;
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) VM Create  Operation not performed; EXITING$(tput sgr0)";
      exit 1;
    ;;
  esac
}

#This function is to prompt wheather user is able to access sudo or not!!!!
chkSudoer(){
  if [[ $USER == "root" ]]; then
  	return ;
  fi 
  count=$( groups $USER | grep "sudo" | wc -l )
  if [[ $count -eq 0 ]]; then
    echo " $(tput setaf 1) User $USER does not has sudo access; EXITING $(tput sgr 0) "
    exit 1;
  else
    return
  fi
}


# The script starts from Here
echo -e "$(tput setaf 2) \n USAGE: bash createUbuntu20.04.sh vmName vmRAM(MiB) vCPU vmDiskSize(GiB) \n";
echo "$(tput setaf 4) This script will create a new Ubuntu VM ";

# check for valid arguments
## vmName 
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) vmName not provided; EXITING $(tput sgr 0)";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid VM name; EXITING $(tput sgr 0)"
  exit 1;
else
  vmChk=$(virsh dumpxml $1 2>&1);
  errCode=$(echo $vmChk | grep error | wc -l)
  if [[ $errCode -eq 0 ]]; then
    echo "$(tput setaf 1) $1 machine Already Exists; EXITING $(tput sgr 0)";
    exit 1;
  fi
fi

## vmRam
if [[  $2 == "" ]]; then
  echo "$(tput setaf 1) vmRAM not provided; EXITING $(tput sgr 0)";
  exit 1;
elif ! [[ $2 =~ ^[0-9]+$ ]]; then
  echo "$(tput setaf 1) $2 is not a valid RAM Size; EXITING $(tput sgr 0)"
  exit 1;
else
  # check RAM size
  ramKiB=$( virsh nodeinfo | grep Memory | awk '{print $3}' )   # Get RAM of System in KiB
  ramMiB=$( echo "scale=10;$ramKiB/1024" | bc )                 # Convert RAM KiB into MiB

  if ((  $(echo "$2 > $ramMiB" |bc -l) )); then
    echo "$(tput setaf 1) $2 Insufficient RAM; EXITING $(tput sgr 0)"
    exit 1;
  fi
fi

## vCPU  
if [[  $3 == "" ]]; then
  echo "$(tput setaf 1) vmCPU not provided; EXITING $(tput sgr 0)";
  exit 1;
elif ! [[ $3 =~ ^[0-9]+$ ]]; then
  echo "$(tput setaf 1) $3 is must be integer number; EXITING $(tput sgr 0)"
  exit 1;
else
  # Check CPU's
  totalCPUS=$(virsh nodeinfo | grep -w "CPU(s)" | awk '{print $2}')      # Get total cpu's
  if [[ $totalCPUS -lt $3 ]]; then
    echo "$(tput setaf 1) $1 is exceeding TOTAL CPU'S ( i.e. totalCPU=$totalCPUS ); EXITING $(tput sgr 0)";
    exit 1;
  fi
fi

## vmDiskSize
if [[  $4 == "" ]]; then
  echo "$(tput setaf 1) vmDiskSize not provided; EXITING $(tput sgr 0)";
  exit 1;
elif ! [[ $4 =~ ^[0-9]+$ ]]; then
  echo "$(tput setaf 1) $4 is not a valid Disk Size; EXITING $(tput sgr 0)"
  exit 1;
else
  availDsize=$(df -h | grep -w / | awk '{print $4}')   # Get available system disk size like 94G
  dSize=$(echo ${availDsize::-1})                      # Remove G's from $availDsize

  if (( $(echo "$2 > $ramMiB" |bc -l) )); then
  echo "$(tput setaf 1) Insufficient Disk Size; EXITING $(tput sgr 0)"
  exit 1;
  fi
fi

userCh       # calling userCh function 
chkSudoer    # calling chkSudoer function

# save arguments values into a variables
vmName=$1
vmRAM=$2
vCPU=$3
vmDiskSize=$4

# Create a new VM 
virt-install \
--name $vmName \
--ram $vmRAM \
--disk path=/var/lib/libvirt/images/"$vmName".qcow2,size="$vmDiskSize" \
--vcpus "$vCPU" \
--os-type linux \
--os-variant ubuntu20.04 \
--network bridge=virbr0 \
--graphics none \
--console pty,target_type=serial \
--location  'http://us.archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/' \
--extra-args 'console=ttyS0,115200n8 serial'


# Reference link to down centos 8
# Goto centos.org website
# Links
# 1. http://jp.archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/
# 2. https://serverfault.com/questions/364895/virsh-vm-console-does-not-show-any-output
