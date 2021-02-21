#!/usr/bin/env bash

userCh() {
  read -p "$(tput setaf 3) Do you wants to continue ? (yes | no )$(tput sgr0) " choice
  case $choice in
  Yes | yes | y | Y)
    echo ""
    ;;
  *)
    echo "$(tput setaf 1) Key Distribution test operation not performed; EXITING;$(tput sgr0)"
    exit 1
    ;;
  esac
}

# check vm connectivity
chkConn() {
  chkVm=$1
  usr=$2
  c=0
  while [ $c -lt 10 ]; do
    echo "$(tput setaf 3)   Trying to connect $chkVm:$(tput sgr0)  $c";
    # check connectivity for $chkVm
    result=$(ping -qc1 $chkVm)
    status=$(echo $?)
    if [[ $status -eq 0 ]]; then
      echo "$(tput setaf 2)   $chkVm able to connect$(tput sgr0) "
      ssh -o StrictHostKeyChecking=no $usr@$chkVm 'exit ';
      return
    fi
    ((c++))
  done
  echo "$(tput setaf 1) $chkVm not able to connect; EXITING$(tput sgr0) "
  exit 1
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
    res=$(virsh desc $vm)
    if [ "$res" == "" ]; then
      echo "$(tput setaf 1) $vm machine does not exists; EXITING";
      exit 1;
    fi
  done
}

#
# From $vm1 create a file on $vm using echo "Hello from $vm1 to $vm" > hello-from-base-local.txt
# In next step, login to $vm and check if hello-from-base-local.txt exist
testKeyDistro() {
  base=$1
  vm=$2
  usr=$3
  ssh_exit_status=0

  ssh_exit_status=$(echo $?)   # exit status 
  
  ssh -tq $user@$base ' ssh_out=$(ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=publickey '$usr'@'$vm' "exit 0" 2>&1) ;
                        ssh_ext=$(echo $?);
                       	
                      # check if error is due to Permission denied or not
				   	             ssh_err_chk=$(echo $ssh_out | grep "Permission denied" | wc -l)
					               if [ $ssh_err_chk -eq 1 ]; then
					   		            echo "$(tput setaf 1) Permission denied";
					    	            exit 1;
						             fi
						
					            # if there is a connectionloss try to re-connect
                      c=1
					          	while [ "$ssh_ext" -gt 0 ]; do
                        sleep 3
                        ssh_out=$(ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=publickey '$usr'@'$vm' "exit 0" 2>&1) ;
                       	ssh_ext=$(echo $?);
                       	   
                        # check if error is due to Permission denied or not
                       	ssh_err_chk=$(echo $ssh_out | grep "Permission denied" | wc -l)
                       	if [ $ssh_err_chk -eq 1 ]; then
                       	  echo "$(tput setaf 1) Permission denied";
                       	  exit 1;
                       	fi
                       	echo "  Trying to connect to '$vm '";
                       	if [ "$c" -eq 3  ]; then
                    		  break
                       	fi
                       	((c++));
                      done
                       	
                      if [ $ssh_ext -gt 0 ]; then
                        echo $ssh_out;
                        exit 1;
                      fi
                     '  # end of ssh base
                     
  ssh_exit_status=$(echo $?)
  if [ "$ssh_exit_status" -gt 0 ]; then
    echo "$(tput setaf 1) From '$user@$base' machine to '$usr@$vm' machine Key Distribution Test Operation Failed; EXITING;$(tput sgr0)"
    exit
  fi                         
  echo "$(tput setaf 2)   $base $vm ---> $usr $(tput sgr0)"
  return 0
}

# script starts from here
user=$2
echo -e "\n$(tput setaf 2) USAGE: bash testkeyDistro2.sh vmlistFilename userName $(tput sgr0)\n"
echo "$(tput setaf 4) This script perform a test to check whether baseLocal and console machine able to login to all vm's end with .sb without password $(tput sgr0)"

# if mosipVm.list is not available? add validation. Read the vmList as input parameter to the list
if [[  $1 == "" ]]; then
  echo "$(tput setaf 1) File name not provided; EXITING$(tput sgr0)";
  exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
  echo "$(tput setaf 1) $1 is not a valid file name; EXITING$(tput sgr0) "
  exit 1
elif [[ ! -f $1 ]]; then
  echo "$(tput setaf 1)File $1 not found; EXITING $(tput sgr0) ";
  exit 1;
elif [[ -z $2 ]]; then
	echo "$(tput setaf 1)user name not provided; EXITING $(tput sgr0) "
	exit 1;
elif [[ "$2" != "mosipuser"  && $2 != "root" ]]; then
	echo "$(tput setaf 1)user name must be either mosipuser or root; EXITING$(tput sgr0) "
	exit 1;	  
fi

# calling userCh function which will ask you whether they want to continue or not
userCh  # calling userCh function

# save the content of the file mosipVm.list in a variable
vmList=$(<$1)
chkVmFile $1      # calling checkVmFile function

i=1                 # for machine number

# Iterate through input file, check existence and connectivity :
echo
echo -n " ---------- VM connectivity test "; printf '%*.0s\n' $(( $(tput cols)-33)) "" | tr " " "-"
for vm in $vmList; do
  # start vm's console machine
	status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "running" ]]; then
	  echo  "$(tput setaf 2)   Domain $vm Running$(tput sgr0)"
 	else
    tput setaf 10;
    echo -n " "
    virsh start $vm;
    tput sgr0;
 	fi 
done

# test connectivity from trex to $vm machine
for vm in $vmList; do
  echo ""
  echo -e "$(tput setaf 6) [ $vm ] $(tput sgr0)" ;
	chkConn $vm  "mosipuser" # calling chkConn function
	chkConn $vm  "root" # calling chkConn function
done

i=1
user=$2
echo
echo -n " ---------- BaseLocal & console Machine Key Distribution Test ";
printf '%*.0s' $(( $(tput cols)-63)) "" | tr " " "-"
# Iterate thru input file and check existence:
for vm in $vmList; do
  echo -e "\n"
  echo -e "$(tput setaf 6) [ $vm ] $(tput sgr0)" ;
  # baseLocal machine
  if [ $i -eq 1 ]; then
    baseLocal=$vm
  # console machine
  elif [ $i -eq 2 ]; then
    testKeyDistro $baseLocal $vm  "mosipuser"      # calling  MkAndChkFile function and passing baseLocal machine and vm for mosipuser
    testKeyDistro $baseLocal $vm  "root"      # calling  MkAndChkFile function and passing baseLocal machine and vm for root user
    console=$vm
  else
    testKeyDistro $baseLocal $vm  "mosipuser"      # calling  MkAndChkFile function and passing baseLocal machine and vm
    testKeyDistro $baseLocal $vm  "root"      # calling  MkAndChkFile function and passing baseLocal machine and vm
    testKeyDistro $console $vm  "mosipuser"      # calling  MkAndChkFile function and passing baseLocal machine and vm
    testKeyDistro $console $vm  "root"      # calling  MkAndChkFile function and passing baseLocal machine and vm
  fi
  ((i++))
done
echo -e "$(tput setaf 2)\n Key Distribution test Successfully executed !!! $(tput sgr0) "