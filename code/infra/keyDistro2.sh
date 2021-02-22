#!/usr/bin/env bash

# this function ask user whether they want to continue the script or not
userCh(){
  read -p  "$(tput setaf 3) Do you wants to continue ? (yes | no )$(tput sgr0) " choice
  case $choice in
   	Yes|yes|y|Y)
      echo "";
    ;;
    *)
      echo "$(tput setaf 1) Key Distribution operation not performed; EXITING$(tput sgr0) ";
      exit 1;
    ;;
  esac
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
      ssh -o StrictHostKeyChecking=no "$user"@$vm  "exit 0"
      return ;
    fi
    ((c++))
  done


  #When user is not able to connect vm
  echo "$(tput setaf 1) $chkVm not able to connect at $user; EXITING"
  exit 1
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

# User if she wants to use it as baseLocal machine. If user says not yes, report exit.
# User if she wants to use it as console machine. If user says not yes, report exit.
useVmAs(){
	case $2 in
    Yes|yes|y|Y)
      echo "$(tput setaf 2) $1 machine is now a $3 machine $(tput sgr0) "
      return 1;
    ;;
    No|no|N|n)
      echo "$(tput setaf 1) $1 machine must be used as $3 Machine; EXITING$(tput sgr0) "
      exit 1;
    ;;
    *)
      echo "$(tput setaf 1) Invalid option; EXITING ";
      exit 1;
    ;;
	esac
	return 0;
}

# check ssh key
chkMakeKey(){
  echo -e "\n   Generate SSH KEY for User --> $2\n"
  tput setaf 5
  vm=$1
  usr=$2
  ssh_exit_status=0
	ssh $usr@$vm  " if [[ ! -f ~/.ssh/id_rsa.pub  || ! -f ~/.ssh/id_rsa ]]; then
	                    echo -e '\ny' | ssh-keygen -t rsa -b 2048 -N '' ;
	                    "ssh_exit_status"=$(echo $?)

  						        if [ "$ssh_exit_status" -gt 0 ]; then
    								    echo 'Failed to Generate SSH key; EXITING'
    								    exit 1;
  							      fi
  							      exit 0;
	                fi
	              " # end of ssh

  ssh_exit_status=$(echo $?)
  tput sgr0
  if [ $ssh_exit_status -gt 0 ]; then
    echo "$(tput setaf 1)Key Distribution test Failed; EXITING$(tput sgr0)"
    exit 1;
  fi
}

# Check autorized_keys file existence, if not create it.
# Set right permissions on this file checkMakeAuthorizedKeys(VM)
chkMakeAuthorizedKeys(){
  vm=$1
  usr=$2
  ssh $usr@$vm "mkdir -p ~/.ssh/; chmod  700 ~/.ssh/;"
  permission=$(ssh $usr@$vm " touch ~/.ssh/authorized_keys;
          			               ls -l ~/.ssh/authorized_keys | awk '{print \$1}' ;
  			          					" )

  if [ $permission != "-rw-------." ]; then
    ssh $usr@$vm 	"chmod 600 ~/.ssh/authorized_keys;"
	  echo "$(tput setaf 3)   Permission changed at for $vm machine $(tput sgr0)";
  fi
}

# Add BaseLocal and console machine ssh public key to *.sb vm machines
addKey2Vm(){

  vm="$1";
  sshkey="$2";
  usr=$4

  count_SSHkey=$(ssh $usr@$vm 'cat ~/.ssh/authorized_keys | grep "'$sshkey'" | wc -l ');

  if [ $count_SSHkey -eq 0 ]; then
    ssh $usr@$vm 'echo "'$sshkey'">>~/.ssh/authorized_keys ';
   	echo "$(tput setaf 3)   $3 machine ssh key inserted in $vm machine for user --> $4 $(tput sgr0)";
    return ;
  fi
  echo "$(tput setaf 2)   $3 machine ssh key already present in $vm for user ---> $4!! $(tput sgr0) ";
}

# The script starts from here
echo -e "$(tput setaf 2) \n USAGE: bash keyDistro2.sh vmlistFilename userName\n";
echo "$(tput setaf 4) This script will make baseLocal and console machine have passwordLess access to all vm's end with .sb ";

#if mosipVm.list is not available? add validation. Read the vmList as input parameter to the list
if [[  $1 == "" ]]; then
   echo "$(tput setaf 1) File name not provided; EXITING$(tput sgr0) ";
   exit 1;
elif ! [[ $1 =~ ^[0-9a-zA-Z/._-]+$ ]]; then
   echo "$(tput setaf 1) $1 is not a valid file name; EXITING $(tput sgr0) "
   exit 1
elif [[ ! -f $1 ]]; then
   echo "$(tput setaf 1) File $1 not found; EXITING $(tput sgr0) ";
   exit 1;
elif [[ -z $2 ]]; then
	echo "$(tput setaf 1) user name not provided; EXITING $(tput sgr0) "
	exit 1;
elif [[ "$2" != "mosipuser"  && $2 != "root" ]]; then
	echo "$(tput setaf 1) user name must be either mosipuser or root; EXITING $(tput sgr0) "
	exit 1;
fi

# calling userCh function which will ask you whether they want to continue or not
userCh  # calling userCh function

# for machine number
i=1;
# save the contents of the file mosipVm.list in a variable
vmList=$(<$1);
user=$2
chkVmFile $1   # calling checkVmFile function

# Iterate thru input file and check existence:
for vm in $vmList; do
	if [ $i -eq 1 ]; then
		read -p "$(tput setaf 3) Do wants to use $vm as BaseLocal machine ? (yes | no ) $(tput sgr0) " choice
		useVmAs "$vm" "$choice" "BaseLocal"
	  echo ""
	elif [ $i -eq 2 ]; then
		read -p  "$(tput setaf 3) Do wants to use $vm as console machine ? (yes | no ) $(tput sgr0)"  choice
		useVmAs "$vm" "$choice" "console"
	else
	  continue
	fi
	((i++))
done

# start all vm's
echo -n " --------- VM connectivity test ";
printf '%*.0s\n' $(( $(tput cols)-32)) "" | tr " " "-"
for vm in $vmList; do
 	status=$(virsh list --all | grep -w "$vm" | awk '{print $3}')
 	if [[ "$status" == "running" ]]; then
	  echo -e "$(tput setaf 2) \n  Domain $vm Running$(tput sgr0)"
 	else
  	echo -n "  "
    tput setaf 10
    virsh start $vm;
    tput sgr0
 	fi
done

#  test connectivity from trex to $vm machine
for vm in $vmList; do
	echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
	chkConn $vm  "root" # calling chkConn function
	chkConn $vm  "mosipuser" # calling chkConn function
done

# Iterate through specified file and add ssh key to vm's
i=1
echo -e "\n"
echo -n " ---------- ADD BaseLocal & Console machine SSH Key To alll *.sb Machine ";
printf '%*.0s' $(( $(tput cols)-75)) "" | tr " " "-"; echo -e "\n";

user=$2
for vm in $vmList; do
  	echo -e "\n $(tput setaf 6)[ $vm ] $(tput sgr0)";
	if [ $i -eq 1 ]; then
		chkMakeKey $vm "root" ;         						 # calling checkMakeKey function for root user
		chkMakeKey $vm "mosipuser";      						 # calling checkMakeKey function for mosipuser
		mblKey=$(ssh $user@$vm "cat ~/.ssh/id_rsa.pub");         # Getting mosipBaseLocal SSH key 
		addKey2Vm $vm "$mblKey" "baseLocal" "mosipuser";         # ADDING baselocal ssh keys to baselocal machine for user mosipuser
		addKey2Vm $vm "$mblKey" "baseLocal" "root";              # ADDING baselocal ssh keys to baselocal machine for user root user

	elif [ $i -eq 2 ]; then
	    chkMakeKey $vm "root" ;          # calling checkMakeKey function for root user
		chkMakeKey $vm "mosipuser";      # calling checkMakeKey function for mosipuser
		consoleKey=$(ssh $user@$vm "cat ~/.ssh/id_rsa.pub");

		chkMakeAuthorizedKeys $vm "mosipuser";
		chkMakeAuthorizedKeys $vm "root";

		addKey2Vm $vm "$mblKey" "baseLocal" "mosipuser";
		addKey2Vm $vm "$mblKey" "baseLocal" "root";
		
		addKey2Vm $vm "$consoleKey" "console" "mosipuser";
		addKey2Vm $vm "$consoleKey" "console" "root";

	else
		chkMakeAuthorizedKeys $vm "mosipuser";            # calling checkMakeAuthorizedKeys
    	chkMakeAuthorizedKeys $vm "root";

		addKey2Vm $vm "$mblKey" "baseLocal" "mosipuser";
		addKey2Vm $vm "$mblKey" "baseLocal" "root";
		
		addKey2Vm $vm "$consoleKey" "console" "mosipuser";
		addKey2Vm $vm "$consoleKey" "console" "root";
	fi
	((i++));
	echo "";
done

echo "$(tput setaf 2)  Key Distributed successfully !!!"