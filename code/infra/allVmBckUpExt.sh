#!/usr/bin/env bash

#This function says whether user want to continue with the script or not.
userCh(){
  read -p  "$(tput setaf 3) DO you want to continue ? (yes | no )$(tput sgr0) " choice
  case $choice in
    Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) BackUp Operation not performed; EXITING";
      exit 1;
    ;;
  esac
}

# Check VM Existence, if VM does not exist then report and exit. use "virsh desc $VM" to check the existence.
# chk filename and wheather all vm names are valid or not.
chkVmFile(){
  # saving the content of a file into a variable 'file'.
  file=$(<$1);
  
  #Iterate through input file and chk for vm valid names and also their exisitence:
  for vm in $file; do
    # chk vm names
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
# if file not there it will take backup of all vm xml files
bckUpXML(){
  vm=$1
  chkpt=$2
    
  # check vm's xml file existence   
  if [[  -f $loc/$vm-$chkpt.xml ]]; then
    echo "$(tput setaf 1)   $loc/$vm-$chkpt.xml file already exist; EXITING$(tput sgr0)";
	  exit 1;
  # check vm;s image file existence
  elif [[  -f $loc/$vm-$chkpt.qcow2 ]]; then
	  echo "$(tput setaf 1)   $loc/$vm-$chkpt.qcow2 file already exist; EXITING$(tput sgr0)"
    exit 1;
  fi

  # Save the vm's xml file to AllVmBckUpExt Directory  
  sudo virsh dumpxml $vm > $loc/$vm-$chkpt.xml ;
}

# if file not there it will take backup of all vm disk files
bckUpQcow2(){
  vm=$1
  chkpt=$2
    
  # check for vm image file  
  if [[  -f $loc/$vm-$chkpt.qcow2 ]]; then
    echo "$(tput setaf 1) File already exist; EXITING$(tput sgr0)"
    exit 1;
  fi
    
  # get image path  
  imgPath=$(virsh domblklist $vm | grep .qcow2 | awk '{ print $2}')
    
  # copy vm image to AllVmBckUp Directory  
  sudo cp $imgPath $loc/$vm-$chkpt.qcow2 ;
    
  # Check if snapshots are present or not. 
    # If present copy and save it under AllVmBckUpExt Directory   
     
  snpExt=$(sudo ls /var/lib/libvirt/qemu/snapshot/$vm 2>&1)
  snpExtCount=$(echo $snpExt | grep "No such file or directory" | wc -l )
    
  if [[ $snpExtCount -eq 1 ]]; then
	  echo "$(tput setaf 6)   No Snapshots present; SKIPPING;"
    return ;
  fi
    
 # count Snapshots
  snpShtCount=$(sudo ls /var/lib/libvirt/qemu/snapshot/$vm | wc -l )
    
  if [[ $snpShtCount -eq 0 ]]; then
    echo "$(tput setaf 6)   No Snapshots present; SKIPPING"
    return ;
  fi
    
  # Copy Snapshots and save it under AllVmBckUpExt Directory    
  sudo cp -r /var/lib/libvirt/qemu/snapshot/$vm $loc/
}



# script starts from here
echo -e "\n$(tput setaf 2) USAGE: bash allVmBckUpExt.sh mosipVm.list 1-keyDistro ";
echo -e "\n$(tput setaf 4) This script will make BackUp of all vm's present in input file under  ~/allvmBckExt directory";

#To check wheather all arguments are present and valid or not.
#Check mosipVm.list file present and valid or not.
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING$(tput sgr0) ";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid file name; EXITING$(tput sgr0) "
  exit 1
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1) File $1 not found; EXITING $(tput sgr0) ";
  exit 1;
fi

# check the extention of files is given correct or not 
chkpt=$2
if [[  $2 == "" ]]; then
  echo "$(tput setaf 1) checkpoint not provided; EXITING$(tput sgr0) ";
  exit 1;
elif ! [[ $2 =~ ^[0-9a-zA-Z._-]+$ ]]; then
  echo "$(tput setaf 1) checkpoint $chkpt is not a valid file name; EXITING$(tput sgr0) "
  exit 1
fi

# Arguments vmListFile, chkPtName, location to save backup
vmList=$(<$1)
chkpt=$2
loc="$HOME/allVmBckUpExt/$chkpt"

# check point validation
if [[ -d $loc ]]; then
  echo "$(tput setaf 1) Check Point $loc Already Exist; EXITING $(tput sgr0) ";
  exit 1;
fi

# calling userCh function which will ask you whether they want to continue or not
userCh            # calling userch function
chkVmFile $1    # calling checkVmFile function

# To check wheather sudoer or not!!!!
chkSudoer         # calling check sudoer function

# listing all files
virsh list --all

# To shutdown before taking backup 
# Shutdown all vm's
echo -n " --------- Shutdown VM's & Check its Status ";
printf '%*.0s\n' $(( $(tput cols)-45)) "" | tr " " "-"
for vm in $vmList; do
  vmShutdown $vm    # calling vmShutdown function
done
# sleep 10;           # sleep for 10 seconds
# Check vm status
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  chkVmStatus $vm
done    # End of For Loop

# make directory to store all backup files
mkdir -p $loc

# backup xml and disk file
echo -e "\n"
echo -n " --------- BackUp VM's ";
printf '%*.0s\n' $(( $(tput cols)-24)) "" | tr " " "-"
for vm in $vmList; do
  echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
  bckUpXML $vm $chkpt         # calling bckUpXML function
  bckUpQcow2 $vm $chkpt       # calling bckUpQcow2 function
  echo "$(tput setaf 3)   BackUp has been taken successfully for $vm machine$(tput sgr0)"

 # Changing the file permission of snapshots
  chmodRes=$(sudo chmod -R 777 $loc/$vm 2>&1)

  chmdResCount=$(echo $chmodRes | grep -w "No such file or directory" | wc -l )

  if [[ $chmdResCount -eq 1 ]]; then
    continue
  fi
done

echo -e "$(tput setaf 2)\n BackUp has been taken successfully all vm's!!!$(tput sgr0)"