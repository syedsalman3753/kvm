#!/usr/bin/env bash

# The script starts from Here
echo -e "\n$(tput setaf 2)  USAGE: bash vmRemove.sh vmName \n $(tput sgr0)"
if [ "$#" -eq 0 ]; then
	echo "VM name not provided; Exiting;"
	exit 1
elif [ "$#" -gt 1 ]; then
	echo "$(tput setaf 1) only one Argument is Allowed; Exiting; $(tput sgr0)"
	exit 1
fi

vmName=$1

read -p "$(tput setaf 3) Are you sure you want to forever destroy $vmName? $(tput sgr0)" -n 1 -r
echo    # (optional) move to a new line

if ! [[ $REPLY =~ ^[Yy]$ ]]; then
	echo "$(tput setaf 1) VM Remove operation not performed; EXITING; $(tput sgr0)";
    exit 1
else
	errCount=$(virsh desc $vmName 2>&1 | grep error | wc -l)
	if [[ $errCount -eq 1 ]]; then
		echo "$(tput setaf 1) $vmName machine doesn't Exist; Exiting; $(tput sgr0)"
		exit 1
	fi
fi


virsh shutdown $vmName
virsh undefine $vmName
virsh vol-delete $vmName.qcow2 --pool default