# Clone a virtual machine in KVM

* To clone from an Existing virtual machine in KVM. Follow the below steps

## 1. Make A git Clone of KVM repository

* Install git on your local machine

```
[host@machine ~]$  sudo yum install git -y
```

* Goto kvm repository [link](https://github.com/123iris/kvm.git) 

```
[host@machine ~]$  cd ~
[host@machine ~]$  git clone https://github.com/123iris/kvm.git
```

## 2. Goto infra directory

```
[host@machine ~]$  cd ~/kvm/code/infra/
```

## 3. Check VM clone.sh file

```
[host@machine ~]$  ls
createVmCentos7.sh  vmClone.sh  vmRemove.sh
```

## 4. Run vmClone.sh file to create centos78Base machine

```
[host@machine ~]$ bash vmClone.sh centos78Base centos7Base

Are you sure you want to clone centos78Base from centos7Base? y
Clone centos78Base from centos7Base
[sudo] password for host: 
Allocating 'centos78Base.qcow2'                                                                                        | 8.0 GB  00:00:03     

Clone 'centos78Base' created successfully.
Correct the host name
[   0.0] Examining the guest ...
[   5.3] Setting a random seed
[   5.4] Setting the hostname: centos78Base
[   5.5] Finishing off
Cleanup logs etc
[   0.0] Examining the guest ...
[   2.7] Performing "abrt-data" ...
[   2.7] Performing "backup-files" ...
[   3.3] Performing "bash-history" ...
[   3.3] Performing "crash-data" ...
[   3.3] Performing "cron-spool" ...
[   3.3] Performing "dovecot-data" ...
[   3.4] Performing "logfiles" ...
[   3.5] Performing "passwd-backups" ...
[   3.5] Performing "puppet-data-log" ...
[   3.6] Performing "sssd-db-log" ...
[   3.6] Performing "tmp-files" ...
Domain description updated successfully
Domain title updated successfully
```

* list machine

```
[host@machine ~]$ virsh list --all

 Id   Name           State
-------------------------------
 -    centos78Base   shut off
 -    centos7Base    shut off
 -    nseCollectVm   shut off

```

## 5. Get Mac address for centos78Base machine

* Now add Mac address of centos78Base to default network file

```
[host@machine ~]$ virsh dumpxml centos78Base | grep mac
  <type arch='x86_64' machine='pc-q35-4.2'>hvm</type>
     <mac address='52:54:00:b9:8c:c3'/>
```

## 6. Add MAC address, IP address to default network 

```
[host@machine ~]$ virsh net-edit default
# Will bring up the editor
# Add following lines in the dhcp section of the XML, like so:
<network>
  <name>default</name>
  <uuid>90aae6fb-c6c4-415f-af9a-4a4b4c9f7145</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:4a:8b:c4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
      <host mac='52:54:00:02:19:20' name='centos7Base' ip='192.168.122.3'/>
      <host mac='52:54:00:b9:8c:c3' name='centos78Base' ip='192.168.122.4'/>  # like this
    </dhcp>
  </ip>
</network>
```

* Add the IP address to /etc/hosts file

```
[host@machine ~]$ sudo vim /etc/hosts

127.0.0.1       localhost
127.0.0.1       www.localhost
127.0.1.1       machine
192.168.122.3   centos7Base
192.168.122.4   centos78Base     # like this

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

```

* Restart the virtual network for assignements to take effect:

```
[host@machine ~]$ virsh net-destroy default
[host@machine ~]$ virsh net-start default
```
* Now verify whether you are able to access vms using IP address

```
[host@machine ~]$ virsh list --all

 Id   Name           State
-------------------------------
 -    centos7Base    shut off
 -    centos78Base   shut off
```
```
[host@machine ~]$ virsh start centos78Base 
Domain centos78Base started
```

```
[host@machine ~]$ virsh net-dhcp-leases default 

 Expiry Time           MAC address         Protocol   IP address         Hostname       Client ID or DUID
-----------------------------------------------------------------------------------------------------------
 2021-02-21 20:21:29   52:54:00:02:19:20   ipv4       192.168.122.3/24   centos7Base    -
 2021-02-21 20:58:36   52:54:00:b9:8c:c3   ipv4       192.168.122.4/24   centos78Base   -

```

* As its a clone copy of centos7Base machine. we can have passwordless access 

```
[host@machine ~]$ ssh mosipuser@centos78Base 

[mosipuser@centos78Base ~]$ 
```

## 7. Update centos from centos7.7 to centos7.8

* Check centos version 

```
[mosipuser@centos78Base ~]$ cat /etc/centos-release
CentOS Linux release 7.7.1908 (Core)
```

* Update to centos7 to centos 7.8

```
[mosipuser@centos78Base ~]$ sudo yum clean all
[mosipuser@centos78Base ~]$ sudo yum update -y
[mosipuser@centos78Base ~]$ sudo reboot
```
* Now, check the centos version

```
[mosipuser@centos78Base ~]$ cat /etc/centos-release
CentOS Linux release 7.8.2003 (Core)
```

* Shutdown centos78Base machine

```
[mosipuser@centos78Base ~]$ virsh shutdown centos78Base
Domain centos78Base is being shutdown
```

* Execute this command

```
[host@machine ~]$ sudo virt-sysprep -d centos78Base --enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
 
[   0.0] Examining the guest ...
[   2.8] Performing "abrt-data" ...
[   2.8] Performing "backup-files" ...
[   3.6] Performing "bash-history" ...
[   3.6] Performing "crash-data" ...
[   3.6] Performing "cron-spool" ...
[   3.7] Performing "dovecot-data" ...
[   3.7] Performing "logfiles" ...
[   3.8] Performing "passwd-backups" ...
[   3.8] Performing "puppet-data-log" ...
[   3.8] Performing "sssd-db-log" ...
[   3.8] Performing "tmp-files" ...
```

* Provide Domain description

```
[host@machine ~]$ virsh desc centos78Base upgraded from centos7Base
Domain description updated successfully
```

* Update Domain Details

```
[host@machine ~]$ virsh desc centos78Base --title centos78Base
Domain title updated successfully
```


# Clone a List of Machine from centos78Base machine 

* Clone Virtual machines with this Names & IP's address

```
1.  mosipBaseLocal 192.168.122.5
2.  console.sb     192.168.122.6
3.  mzmaster.sb    192.168.122.7
4.  mzworker0.sb   192.168.122.8
5.  mzworker1.sb   192.168.122.9
6.  mzworker2.sb   192.168.122.10
7.  dmzmaster.sb   192.168.122.11
8.  dmzworker0.sb  192.168.122.12
9.  nseCollectVm   192.168.122.13
```

* Run this command to clone machines

```
[host@machine ~]$ cd ~/kvm/code/infra

[host@machine infra]$ bash vmClone.sh mosipBaseLocal centos78Base
[host@machine infra]$ bash vmClone.sh console.sb centos78Base

[host@machine infra]$ bash vmClone.sh mzmaster.sb centos78Base
[host@machine infra]$ bash vmClone.sh mzworker0.sb centos78Base
[host@machine infra]$ bash vmClone.sh mzworker1.sb centos78Base
[host@machine infra]$ bash vmClone.sh mzworker2.sb centos78Base

[host@machine infra]$ bash vmClone.sh dmzmaster.sb centos78Base
[host@machine infra]$ bash vmClone.sh mzworker0.sb centos78Base
```

* Now add "MAC address" & "IP address" to default network 

```
[host@machine infra]$  virsh dumpxml mosipBaseLocal | grep "mac address"
      <mac address='52:54:00:cc:57:98'/>
[host@machine infra]$  virsh dumpxml console.sb | grep "mac address"
      <mac address='52:54:00:e8:03:cd'/>
 
[host@machine infra]$  virsh dumpxml mzmaster.sb | grep "mac address"
      <mac address='52:54:00:99:dc:4c'/>
[host@machine infra]$  virsh dumpxml mzworker0.sb | grep "mac address"
      <mac address='52:54:00:a1:8f:35'/>
[host@machine infra]$  virsh dumpxml mzworker1.sb | grep "mac address"
      <mac address='52:54:00:72:d5:1d'/>
[host@machine infra]$  virsh dumpxml mzworker2.sb | grep "mac address"
      <mac address='52:54:00:71:b4:d4'/>
      
[host@machine infra]$  virsh dumpxml dmzmaster.sb | grep "mac address"
      <mac address='52:54:00:c7:7e:38'/>
[host@machine infra]$  virsh dumpxml dmzworker0.sb | grep "mac address"
      <mac address='52:54:00:a2:bd:80'/>
      
[host@machine infra]$  virsh dumpxml nseCollectVm | grep "mac address"
      <mac address='52:54:00:21:8f:85'/>
      
```
```
[host@machine ~]$ virsh net-edit default

<network>
  <name>default</name>
  <uuid>90aae6fb-c6c4-415f-af9a-4a4b4c9f7145</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:4a:8b:c4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
      <host mac='52:54:00:02:19:20' name='centos7Base' ip='192.168.122.3'/>
      <host mac='52:54:00:b9:8c:c3' name='centos78Base' ip='192.168.122.4'/>
      
      <host mac='52:54:00:cc:57:98' name='mosipBaseLocal' ip='192.168.122.5'/>
      <host mac='52:54:00:e8:03:cd' name='console.sb' ip='192.168.122.6'/> 
       
      <host mac='52:54:00:99:dc:4c' name='mzmaster.sb' ip='192.168.122.7'/>
      <host mac='52:54:00:a1:8f:35' name='mzworker0.sb' ip='192.168.122.8'/>
      <host mac='52:54:00:72:d5:1d' name='mzworker1.sb' ip='192.168.122.9'/>
      <host mac='52:54:00:71:b4:d4' name='mzworker2.sb' ip='192.168.122.10'/>
      
      <host mac='52:54:00:c7:7e:38' name='dmzmaster.sb'  ip='192.168.122.11'/>
      <host mac='52:54:00:a2:bd:80' name='dmzworker0.sb' ip='192.168.122.12'/>
      
      <host mac='52:54:00:21:8f:85' name='nseCollectVm' ip='192.168.122.13'/>
    </dhcp>
  </ip>
</network>

```

* Update IP's in /etc/hosts file

```
[host@machine ~]$ sudo vim /etc/hosts
192.168.122.3   centos7Base
192.168.122.4   centos78Base
192.168.122.5   mosipBaseLocal
192.168.122.6   console.sb
192.168.122.7   mzmaster.sb
192.168.122.8   mzworker0.sb
192.168.122.9   mzworker1.sb
192.168.122.10  mzworker2.sb
192.168.122.11  dmzmaster.sb
192.168.122.12  dmzworker0.sb
192.168.122.13  nseCollectVm
```

* Restart the virtual network for assignements to take effect:

```
[host@machine ~]$ virsh net-destroy default
[host@machine ~]$ virsh net-start default
```

# Make ALL VM's PASSWORDLESS ACCESS

* create a file which contains all vm's name

```
[host@machine infra]$ vim hostList
centos7Base
centos78Base
nseCollectVm
mosipBaseLocal
console.sb
mzmaster.sb
mzworker0.sb
mzworker1.sb
mzworker2.sb
dmzmaster.sb
dmzworker0.sb
```

* create a file which contains password 

```
[host@machine infra]$ vim password.txt
mosipuser
```

* Run hostKeyDistro.sh or hostKeyDistro2.sh script to make all vm's password Less from Host machine

```
[host@machine infra]$ bash hostKeyDistro.sh hostList password.txt

 USAGE: bash hostkeyDistro2.sh mosipVm.list passwd.txt 

 This script will make Host machine passwordLess access to all vm's listed in mosipVm.list file 
 Do you want to continue ? (yes | no ) y


 Host Key Distributed Successfully !!!

```