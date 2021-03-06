#!/usr/bin/env bash
# Reference: https://ostechnix.com/create-a-kvm-virtual-machine-using-qcow2-image-in-linux/


#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) Do you want to continue ? (yes | no )$(tput sgr0) " choice;
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) VM Import Operation not performed; EXITING$(tput sgr0)";
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

# this function will shutdown the vm
vmShutdown(){
  vm=$1
  status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "shut" ]]; then
	  echo -e "$(tput setaf 2)\n\tDomain $vm Shutdown $(tput sgr0)"
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
      echo -e "$(tput setaf 2)\t$chkVm machine is now Shutdown $(tput sgr0) "
      return ;
    fi
    ((c++))
    sleep 2
  done

  # When user is not able to connect vm
  echo "$(tput setaf 1) Unable Shutdown $chkVm machine; EXITING  $(tput sgr0)"
  exit 1
}

# The script starts from Here
echo -e "$(tput setaf 2) \n USAGE: bash createCentos7Vm.sh vmName vmRAM(MiB) vCPU vmDiskPath(i.e. path to *.qcow2 ) \n";
echo "$(tput setaf 4) This script will create a new VM from Existing disk image (i.e using qcow2 file) ";

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
elif ! [[ -f $4 ]]; then
  echo "$(tput setaf 1) Vm Disk image File $4 not found ; EXITING $(tput sgr 0)"
  exit 1;
fi

userCh       # calling userCh function
chkSudoer    # calling chkSudoer function

# save arguments values into a variables
vmName=$1
vmRAM=$2
vCPU=$3
vmDiskPath=$4

# create new disk Image file using user provided vm image
echo "$(tput setaf 3) Create a new vm Disk Image file using user provided image (.qcow2 file) $(tput sgr 0)"
dir=$(dirname $vmDiskPath )
sudo cp $vmDiskPath "$dir/$vmName.qcow2" 

vmDiskImage="$dir/$vmName.qcow2" 

echo -e "\n $(tput setaf 6)[ $vmName ] $(tput sgr0)";
echo -n "$(tput setaf 9)   [Import-disk] $(tput sgr 0)"
virt-install --name $vmName \
 --memory $vmRAM \
 --vcpus $vCPU \
 --disk $vmDiskImage,bus=sata --import \
 --os-variant centos7.0 \
 --network default   | sed "s,.*,$(tput setaf 2)\t&$(tput sgr0),"
 
 vmIP=$(sudo virsh domifaddr $vmName | awk  'NR>2{print $4}' | awk -F '/' '{print $1}')
 
# shutdown vm
 echo -n "$(tput setaf 9)   [shutdown-Machine] $(tput sgr 0)"
 vmShutdown $vmName    # calling vmShutdown function to shutdown vm
 chkVmStatus $vmIP     # calling chkVmStatus function to check vm status
 
# Update hostname
 echo -ne "$(tput setaf 9)   [update-hostname] $(tput sgr 0)\n"
 echo -e "$(tput setaf 3)\t Update $vmName machine hostname $(tput sgr 0)"  
 sudo virt-customize -d $vmName --hostname $vmName  | sed "s,.*,$(tput setaf 2)\t&$(tput sgr0),"
 
 
# Clear logs
 echo -ne "$(tput setaf 9)   [clear-logs] $(tput sgr 0)\n"

 echo -e "$(tput setaf 3)\t Clear logs other waste data $(tput sgr 0)"
  
 sudo virt-sysprep -d $vmName --enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files \
 | sed "s,.*,$(tput setaf 2)\t&$(tput sgr0)," 
 
# update vm description & title
 echo -ne "$(tput setaf 9)   [update-vm-desc-title] $(tput sgr 0)\n"
 virsh desc $vmName upgraded from centos7Base | sed "s,.*,$(tput setaf 2)\t&$(tput sgr0)," 
 virsh desc $vmName --title centos7Base       | sed "s,.*,$(tput setaf 2)\t&$(tput sgr0),"