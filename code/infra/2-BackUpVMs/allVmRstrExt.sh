#!/usr/bin/env bash

#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) DO you want to continue ? ( yes | no ) $(tput sgr0) " choice
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) All vm's Restore Operation not performed; EXITING$(tput sgr0) ";
      exit 1;
    ;;
  esac
}

# chk VM Existence, if VM does not exist then report and exit. use "virsh desc $VM" to check the existence.
# Check filename and wheather all vm names are valid or not.
chkVmFile(){
  # saving the content of a file into a variable 'file'.
  file=$(<$1);

  #Iterate through input file and check for vm valid names and also their exisitence:
	for vm in $file; do
    if [ "$vm" == "" ]; then
      echo "$(tput setaf 1) Now VM'S Present in input file; EXITING $(tput sgr0) "
      exit 1;
    elif ! [[ "$vm" =~ ^[a-zA-Z0-9_.]+$ ]]; then
      echo "$(tput setaf 1) $vm is not a valid virtual machine name; EXITING$(tput sgr0) "
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

#This function is to prompt wheather user is able to access sudo or not!!!!
chkSudoer(){
  count=$( groups $USER | grep "sudo" | wc -l )
  if [[ $count -eq 0 ]]; then
    echo "$(tput setaf 1) User $USER does not has sudo access; EXITING$(tput sgr0) "
    exit 1;
  else
    return
  fi
}

# check wheather all vm's are in shutdown state or not!!
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
  echo "$(tput setaf 1) Unable Shutdown $chkVm machine ; EXITING$(tput sgr0)"
  exit 1
}

# Deleting all previous xml files 
undfn(){
  vm=$1
  imgPath=$2
  chkpt=$3

  # check if snapshots are present of $vm. If yes delete all snapshots
  snpShtLst=$(virsh snapshot-list $vm | awk 'NR>2{ print $1}')

  # Delete Snapshots for vm's
  for s in $snpShtLst; do
    echo -n "   $(tput setaf 3)"
    virsh snapshot-delete $vm $s
    echo " $(tput sgr0)"
  done

  # Undefine the $vm
  echo -n "   $(tput setaf 3)"
  virsh undefine $vm
  echo "$(tput sgr0)"
}

# Removing all previous disk files
rmv(){
  vm=$1
  pool=$2
  imgPath=$3
  chkpt=$4
      
  if [[ ! -f "$imgPath" || "$imgPath" =~ ^$ ]]; then
    echo "$(tput setaf 6)   File $imgPath not found; SKIPPING $(tput sgr0) ";
    return ;
  fi

  echo "   imgPath=$imgPath"
  echo -n "   $(tput setaf 3)"
  virsh vol-delete $vm.qcow2 --pool $pool
  echo "$(tput sgr0)"
  sudo systemctl restart libvirtd
}

# Restore all qcow2 disk files
rstr(){
  vm=$1
  imgPath=$2
  chkpt=$3
  imgDir=$( dirname $imgPath )

  if [[ ! -f  $loc/$vm-$chkpt.qcow2 ]]; then
    echo  "$(tput setaf 1)   File $loc/$vm-$chkpt.qcow2 not found; EXITING $(tput sgr0) ";
    exit 1;
  fi

  sudo cp $loc/$vm-$chkpt.qcow2 $imgDir/$vm.qcow2
  echo -n "   $(tput setaf 3)Successfully Restored $vm machine from BackUp "
  echo -e "$(tput sgr0)\n"

  sudo systemctl restart libvirtd

  if [[ ! -d $loc/$vm ]]; then
    return
  elif [[ ! -d /var/lib/libvirt/qemu/snapshot/$vm  ]]; then
    sudo cp -r $loc/$vm  /var/lib/libvirt/qemu/snapshot/
    echo -n "   $(tput setaf 3)Successfully Restored snapshots for $vm machine from BackUp $(tput sgr0)"
    echo -e "\n"
  fi

}

# Restore all xml files, So Define all vm's to get XML files back
dfn(){
  vm=$1
  chkpt=$2
  if [[ ! -f "$loc/$vm-$chkpt.xml" ]]; then
    echo "$(tput setaf 1)   dfn file $loc/$vm-$chkpt.xml not found; EXITING $(tput sgr0) ";
    exit 1;
  fi
  echo -n "$(tput setaf 3)   ";
  sudo virsh define --file "$loc/$vm-$chkpt.xml"
  echo "$(tput sgr0)"
}


# script starts from here
echo -e "\n$(tput setaf 2) USAGE: bash allVmRstrExt.sh mosipVm.list chkptName kvmPoolName\n";
echo "$(tput setaf 4) This script will restore vm's present in input file from Backup ( i.e under ~/allvmBckExt )  ";

#To check wheather all arguments are present and valid or not.
#Check mosipVm.list file present and valid or not.
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING $(tput sgr0) ";
  exit 1;
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1) File $1 not found; EXITING $(tput sgr0) ";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid file name; EXITING $(tput sgr0) "
  exit 1
fi

# check the extention of files is given correct or not
if [[  $2 == "" ]]; then
  echo "$(tput setaf 1) Check point not provided; EXITING $(tput sgr0) ";
  exit 1;
elif ! [[ $2 =~ ^[0-9a-zA-Z._-]+$ ]]; then
  echo "$(tput setaf 1) $chkpt is not a valid file name; EXITING $(tput sgr0) "
  exit 1
fi

# kvm pool name
if [[  $3 == "" ]]; then
  echo "$(tput setaf 1) Pool Name not provided; EXITING $(tput sgr0) ";
  exit 1;
elif ! [[ $3 =~ ^[0-9a-zA-Z._-]+$ ]]; then
  echo "$(tput setaf 1) $pool is not a valid pool name; EXITING$(tput sgr0) "
  exit 1
fi

vmList=$(<$1)
chkpt=$2
loc="$HOME/allVmBckUpExt/$chkpt"
pool=$3

# Check BackUp files
for vm in $vmList; do
  if [[ ! -d $loc ]]; then
    echo "$(tput setaf 1) Check Point $loc Not Exist for $vm machine; EXITING $(tput sgr0) ";
    exit 1;
  elif [[  ! -f $loc/$vm-$chkpt.xml  ]]; then
    echo "$(tput setaf 1) BackUp File $loc/$vm-$chkpt.xml Not Exist for $vm machine; EXITING $(tput sgr0) ";
    exit 1;
  elif [[  ! -f $loc/$vm-$chkpt.qcow2 ]]; then
    echo "$(tput setaf 1) BackUp File $loc/$vm -$chkpt.qcow2 Not Exist for $vm machine; EXITING $(tput sgr0) ";
    exit 1;
  fi
done

# calling userCh function which will ask you whether they want to continue or not
userCh  # calling userch function
chkSudoer # calling check sudoer function
chkVmFile $1   # calling checkVmFile function


# To shutdown before taking restore
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
done

echo -e "\n"
echo -n " --------- Restore VM'S from BackUp ";
printf '%*.0s\n' $(( $(tput cols)-37)) "" | tr " " "-"
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  imgPath=$(virsh domblklist $vm | grep .qcow2 | awk '{ print $2}')
  # Remove VM's
  undfn $vm $imgPath $chkpt    # calling undefine function
  rmv  $vm $pool $imgPath      # calling remove function
  # Restore xml and disk file
  chkpt=$2
  dfn $vm $chkpt
  rstr $vm $imgPath $chkpt
done

# listing status of all vm's
virsh list --all

echo "$(tput setaf 2) Successfully Restored All vm's from BackUp !!! $(tput sgr0)"