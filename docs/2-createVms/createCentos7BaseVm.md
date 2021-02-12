# Install centos7Base Virtual MACHINE in KVM

## 1. Make A git Clone of KVM repository

* Install git on your local machine

```
$ sudo yum install git -y
```

* Goto kvm repository [link](https://github.com/123iris/kvm.git) 

```
$ cd ~
$ git clonehttps://github.com/123iris/kvm.git
```

## 2. Goto infra directory

```
$ cd ~/kvm/code/infra/
```

## 3. Check createVmCentos7.sh file

* This script will help you to create new centos7 OS virtual machine in KVM

```
$ ls ~/Documentation/kvm/code/infra/
createVmCentos7.sh
```

## 4. Run createVmCentos7.sh

* Run createVmCentos7.sh script to install a new VM in your local machine

```
$ bash vmCreateCentos7.sh centos7Base 2048 1 8
 
 USAGE: bash createCentos7Vm.sh vmName vmRAM(MiB) vCPU vmDiskSize(GiB) 

 This script will create a new VM 
 Do you want to continue ? (yes | no ) y

```