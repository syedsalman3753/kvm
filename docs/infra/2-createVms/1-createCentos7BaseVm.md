# Install centos7Base Virtual MACHINE in KVM

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
[host@machine ~]$ cd ~/kvm/code/infra/1-createVmCentos/
```

## 3. Check createVmCentos7.sh file

* This script will help you to create new centos7 OS virtual machine in KVM

```
[host@machine 1-createVmCentos]$ ls ~/kvm/code/infra/1-createVmCentos
createVmCentos7.sh createVmCentos8.sh
```

## 4. Run createVmCentos7.sh

* Run createVmCentos7.sh script to install a new VM in your local machine

```
[host@machine ~]$ cd ~/kvm/code/infra/1-createVmCentos/
[host@machine 1-createVmCentos]$ sudo bash createVmCentos7.sh centos7Base 2048 1 8
 
 USAGE: bash createCentos7Vm.sh vmName vmRAM(MiB) vCPU vmDiskSize(GiB) 

 This script will create a new VM 
 Do you want to continue ? (yes | no ) y

```

## 5. Post Installation Steps

* centos7Base is the VM from which every other VM is created for mosip installation.

Follow these directions when they come up during OS installation.

* When the install centos install instructions come up, use Text Mode (Not VNC)
* Set time zone asia / kolkata
* set up NTP: use this server address: ntp-b.nist.gov
* Software selection: minimum install
* Set root password to mosipuser
* Set a user as mosipuser, password mosipuser
* Use defaults for installation destination

Follow these directions when they come up during OS installation.

### I. Select "Use text mode" not VNC & then Enter

```
Starting installer, one moment...
anaconda 21.48.22.156-1 for CentOS 7 started.
 * installation log files are stored in /tmp during the installation
 * shell is available on TTY2
 * when reporting a bug add logs from /tmp as separate text/plain attachments
================================================================================
================================================================================
VNC

Text mode provides a limited set of installation options. It does not offer
custom partitioning for full control over the disk layout. Would you like to use
VNC mode instead?

 1) Start VNC

 2) Use text mode

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 2
```
### II. Select "1" for langauge selection. Use English (United States)

```
================================================================================
Installation

 1) [x] Language settings                 2) [!] Time settings
        (English (United States))                (Timezone is not set.)
 3) [!] Installation source               4) [!] Software selection
        (Processing...)                          (Processing...)
 5) [!] Installation Destination          6) [x] Kdump
        (No disks selected)                      (Kdump is enabled)
 7) [x] Network configuration             8) [!] Root password
        (Wired (eth0) connected)                 (Password is not set.)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 1             # select language setting & then enter
```
```
 1)  Afrikaans             25)  Hindi                 48)  Oriya
 2)  Amharic               26)  Croatian              49)  Punjabi
 3)  Arabic                27)  Hungarian             50)  Polish
 4)  Assamese              28)  Interlingua           51)  Portuguese
 5)  Asturian              29)  Indonesian            52)  Romanian
 6)  Belarusian            30)  Icelandic             53)  Russian
 7)  Bulgarian             31)  Italian               54)  Sinhala
 8)  Bengali               32)  Japanese              55)  Slovak
 9)  Bosnian               33)  Georgian              56)  Slovenian
10)  Catalan               34)  Kazakh                57)  Albanian
11)  Czech                 35)  Kannada               58)  Serbian
12)  Welsh                 36)  Korean                59)  Swedish
13)  Danish                37)  Lithuanian            60)  Tamil
14)  German                38)  Latvian               61)  Telugu
15)  Greek                 39)  Maithili              62)  Tajik
16)  English               40)  Macedonian            63)  Thai
17)  Spanish               41)  Malayalam             64)  Turkish
18)  Estonian              42)  Marathi               65)  Ukrainian
19)  Basque                43)  Malay                 66)  Urdu
20)  Persian               44)  Norwegian Bokmål      67)  Vietnamese
21)  Finnish               45)  Nepali                68)  Chinese
22)  French                46)  Dutch                 69)  Zulu
Press ENTER to continue English                # select langauge & then enter
```
```
Please select language support to install.
[b to return to language list, c to continue, q to quit]: c
```

### III. Select "2" for time setting

```
Installation

 1) [x] Language settings                 2) [!] Time settings
        (English (United States))                (Timezone is not set.)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [!] Installation Destination                 (Kdump is enabled)
        (No disks selected)               8) [!] Root password
 7) [x] Network configuration                    (Password is not set.)
        (Wired (eth0) connected)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 2
```

* Set time zone asia / kolkata

```
Time settings

Timezone: not set

NTP servers:not configured

 1)  Set timezone
 2)  Configure NTP servers
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1                   # select 1 & then enter
```
```
Timezone settings

Available regions
 1)  Europe                 6)  Pacific               10)  Arctic
 2)  Asia                   7)  Australia             11)  US
 3)  America                8)  Atlantic              12)  Etc
 4)  Africa                 9)  Indian
 5)  Antarctica
Please select the timezone.
Use numbers or type names directly [b to region list, q to quit]: 2
```

```
Timezone settings

Available timezones in region Asia
 1)  Aden                  29)  Hong_Kong             56)  Pontianak
 2)  Almaty                30)  Hovd                  57)  Pyongyang
 3)  Amman                 31)  Irkutsk               58)  Qatar
 4)  Anadyr                32)  Jakarta               59)  Qostanay
 5)  Aqtau                 33)  Jayapura              60)  Qyzylorda
 6)  Aqtobe                34)  Jerusalem             61)  Riyadh
 7)  Ashgabat              35)  Kabul                 62)  Sakhalin
 8)  Atyrau                36)  Kamchatka             63)  Samarkand
 9)  Baghdad               37)  Karachi               64)  Seoul
10)  Bahrain               38)  Kathmandu             65)  Shanghai
11)  Baku                  39)  Khandyga              66)  Singapore
12)  Bangkok               40)  Kolkata               67)  Srednekolymsk
13)  Barnaul               41)  Krasnoyarsk           68)  Taipei
14)  Beirut                42)  Kuala_Lumpur          69)  Tashkent
15)  Bishkek               43)  Kuching               70)  Tbilisi
16)  Brunei                44)  Kuwait                71)  Tehran
17)  Chita                 45)  Macau                 72)  Thimphu
18)  Choibalsan            46)  Magadan               73)  Tokyo
19)  Colombo               47)  Makassar              74)  Tomsk
20)  Damascus              48)  Manila                75)  Ulaanbaatar
21)  Dhaka                 49)  Muscat                76)  Urumqi
22)  Dili                  50)  Nicosia               77)  Ust-Nera

Press ENTER to continue 40                                                    # select 40 ( kolkata )

Use numbers or type names directly [b to region list, q to quit]: 40          # select 40 ( kolkata )

```
* set up NTP: use this server address: ntp-b.nist.gov

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [!] Installation Destination                 (Kdump is enabled)
        (No disks selected)               8) [!] Root password
 7) [x] Network configuration                    (Password is not set.)
        (Wired (eth0) connected)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 2 

```

```
Time settings

Timezone: Asia/Kolkata

NTP servers:not configured

 1)  Change timezone
 2)  Configure NTP servers
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 2                  # select 2 for NTP server setting

```

```
================================================================================
NTP configuration

NTP servers:no NTP servers have been configured

 1)  Add NTP server
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1
```
```
================================================================================
================================================================================
Enter an NTP server address and press enter
ntp-b.nist.gov                 # provide the ntp server name & then enter
```

```
NTP configuration

NTP servers:
ntp-b.nist.gov (checking status)

 1)  Add NTP server
 2)  Remove NTP server
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```

### IV. Select "4" for Software selection: minimum install

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [!] Installation Destination                 (Kdump is enabled)
        (No disks selected)               8) [!] Root password
 7) [x] Network configuration                    (Password is not set.)
        (Wired (eth0) connected)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 4
```
```
================================================================================
Base environment
Software selection

Base environment

 1)  [x] Minimal Install                 7)  [ ] Server with GUI
 2)  [ ] Compute Node                    8)  [ ] GNOME Desktop
 3)  [ ] Infrastructure Server           9)  [ ] KDE Plasma Workspaces
 4)  [ ] File and Print Server          10)  [ ] Development and Creative
 5)  [ ] Basic Web Server                        Workstation
 6)  [ ] Virtualization Host
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1
```

```
Base environment
Software selection

Base environment

 1)  [x] Minimal Install                 7)  [ ] Server with GUI
 2)  [ ] Compute Node                    8)  [ ] GNOME Desktop
 3)  [ ] Infrastructure Server           9)  [ ] KDE Plasma Workspaces
 4)  [ ] File and Print Server          10)  [ ] Development and Creative
 5)  [ ] Basic Web Server                        Workstation
 6)  [ ] Virtualization Host
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```

### V. Select '5' for Installation Destination 

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [!] Installation source               4) [!] Software selection
        (Processing...)                          (Processing...)
 5) [!] Installation Destination          6) [x] Kdump
        (No disks selected)                      (Kdump is enabled)
 7) [x] Network configuration             8) [!] Root password
        (Wired (eth0) connected)                 (Password is not set.)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 5
```

* Press 1 to select the disk

```
================================================================================
Probing storage...
Installation Destination

[ ] 1) : 8192 MiB (vda)

No disks selected; please select at least one disk to install to.

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1
```
```
Probing storage...
Installation Destination

[x] 1) : 8192 MiB (vda)

1 disk selected; 8192 MiB capacity; 8192 MiB free ...

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1
```
```
Probing storage...
Installation Destination

[x] 1) : 8192 MiB (vda)

1 disk selected; 8192 MiB capacity; 8192 MiB free ...

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```
* press '2' to use all space from the selected disk

```
Autopartitioning Options

[ ] 1) Replace Existing Linux system(s)

[ ] 2) Use All Space

[ ] 3) Use Free Space

Installation requires partitioning of your hard drive. Select what space to use
for the install target.

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 2 
```
```
Autopartitioning Options

[ ] 1) Replace Existing Linux system(s)

[x] 2) Use All Space

[ ] 3) Use Free Space

Installation requires partitioning of your hard drive. Select what space to use
for the install target.

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```

* Select partition type

```
Partition Scheme Options

[ ] 1) Standard Partition

[ ] 2) Btrfs

[ ] 3) LVM

[ ] 4) LVM Thin Provisioning

Select a partition scheme configuration.

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 3
```
```
Partition Scheme Options

[ ] 1) Standard Partition

[ ] 2) Btrfs

[x] 3) LVM

[ ] 4) LVM Thin Provisioning

Select a partition scheme configuration.

  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```
### VI. Set root password to "mosipuser"

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [x] Installation Destination                 (Kdump is enabled)
        (Automatic partitioning           8) [!] Root password
        selected)                                (Password is not set.)
 7) [x] Network configuration
        (Wired (eth0) connected)
 9) [!] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 8

```
```
================================================================================
Please select new root password. You will have to type it twice.

Password: mosipuser
Password (confirm): mosipuser
```

### VII. Select "9" to Add a new user

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [x] Installation Destination                 (Kdump is enabled)
        (Automatic partitioning           8) [x] Root password
        selected)                                (Password is set.)
 7) [x] Network configuration
        (Wired (eth0) connected)
 9) [ ] User creation
        (No user will be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: 9
```

* Select "1" to add a new user (mosipuser)

```
User creation

 1) [ ] Create user
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 1
```
* Select 3 to provide username (mosipuser)

```
User creation

 1) [x] Create user
 2) Fullname
 3) Username
 4) [ ] Use password
 5) [ ] Administrator
 6) Groups
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 3 
```

* provide username

```
================================================================================
Enter new value for 'Username' and press enter
mosipuser
```
* Select 4 to provide password for mosipuser

```
User creation

 1) [x] Create user
 2) Fullname
 3) Username
    mosipuser
 4) [ ] Use password
 5) [ ] Administrator
 6) Groups
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 4
```
* Select 5 to set password to mosipuser for user 'mosipuser'

```
User creation

 1) [x] Create user
 2) Fullname
 3) Username
    mosipuser
 4) [x] Use password
 5) Password
 6) [ ] Administrator
 7) Groups
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 5
  
================================================================================
================================================================================
Password: mosipuser
Password (confirm): mosipuser
================================================================================
================================================================================

```

* Select 6 to provide administrative access to user

```
User creation

 1) [x] Create user
 2) Fullname
 3) Username
    mosipuser
 4) [x] Use password
 5) Password
    Password set.
 6) [ ] Administrator
 7) Groups
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: 6

```
```
User creation

 1) [x] Create user
 2) Fullname
 3) Username
    mosipuser
 4) [x] Use password
 5) Password
    Password set.
 6) [x] Administrator
 7) Groups
    wheel
  Please make your choice from above ['q' to quit | 'c' to continue |
  'r' to refresh]: c
```

### VIII. Check all options has been checked with cross mark [x]. 
 
* Check Network configuration: eth0
* Check kdump is enabled
  

```
================================================================================
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [x] Installation Destination                 (Kdump is enabled)
        (Automatic partitioning           8) [x] Root password
        selected)                                (Password is set.)
 7) [x] Network configuration
        (Wired (eth0) connected)
 9) [x] User creation
        (Administrator mosipuser will
        be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]:  
```

* Press b to begin installation

```
Installation

 1) [x] Language settings                 2) [x] Time settings
        (English (United States))                (Asia/Kolkata timezone)
 3) [x] Installation source               4) [x] Software selection
        (http://mirror.i3d.net/pub/cent          (Minimal Install)
        os/7/os/x86_64/)                  6) [x] Kdump
 5) [x] Installation Destination                 (Kdump is enabled)
        (Automatic partitioning           8) [x] Root password
        selected)                                (Password is set.)
 7) [x] Network configuration
        (Wired (eth0) connected)
 9) [x] User creation
        (Administrator mosipuser will
        be created)
  Please make your choice from above ['q' to quit | 'b' to begin installation |
  'r' to refresh]: b
```

It will take 20-30 min to completely install machine 

## Allow Non sudo users to work with KVM 

This is followed from [here](https://computingforgeeks.com/use-virt-manager-as-non-root-user/)

* List all vm's 

```
[host@machine ~]$ sudo virsh list --all   
 Id    Name                           State
----------------------------------------------------
 2     centos7Base                    running
 3     console.sb                     Shut off
```

* List running vm's

```
[host@machine ~]$ sudo virsh list 
 Id    Name                           State
----------------------------------------------------
 2     centos7Base                    running

```

* You may have observed that we are able to access the machine only using sudo power

  Now, we need to allow non-sudo user to work with KVM 
  
* Check if this is working

```
[host@machine ~]$ virsh -c qemu:///system list --all
 Id    Name                           State
----------------------------------------------------
 -     centos7Base                    shut off

```
  
* Check whether libvirt group is present or not. If not Create one.

```
[host@machine ~]$ sudo getent group | grep libvirt
libvirt:x:991:
```
* If above didn't work. Some Distribution uses libvirtd. Try this if above didn't work.

```
[host@machine ~]$ sudo getent group | grep libvirtd
```

* If these is no libvirt group. Create one using the following command

```
[host@machine ~]$ sudo groupadd --system libvirt
groupadd: group 'libvirt' already exists
```

* Now Add user account to the libvirt group

```
[host@machine ~]$ sudo usermod -a -G libvirt userName

[host@machine ~]$ sudo usermod -a -G libvirt mosipuser
[host@machine ~]$ sudo usermod -a -G libvirt $(whoami)     # add for current user
```

* Check libvirt group is added to the user

```
[host@machine ~]$ id $(whoami)       # for current user
uid=1000(mosipuser) gid=1000(mosipuser) groups=1000(mosipuser),991(libvirt)
```
```
[host@machine ~]$ id mosipuser
uid=1000(mosipuser) gid=1000(mosipuser) groups=1000(mosipuser),991(libvirt)
```

## Check whether VM is working properly 


* Start a virtual machine using virsh command

```
[host@machine ~]$ virsh start centos7Base
Domain centos7Base started
```

* Enter into centos7Base machine

```
[host@machine ~]$  sudo virsh console centos7Base
Connected to domain centos7Base
Escape character is ^]

CentOS Linux 7 (Core)
Kernel 3.10.0-1062.el7.x86_64 on an x86_64

localhost login: mosipuser

```
* Provide username (mosipuser) & password (mosipuser)

```
centos7Base login: mosipuser
Password: 
Last login: Fri Jan 22 16:55:33 from 192.168.122.1
[mosipuser@localhost ~]$ 
```

* To logout from vm type 'exit' 

```
[mosipuser@localhost ~]$ exit
logout

CentOS Linux 7 (Core)
Kernel 3.10.0-1160.11.1.el7.x86_64 on an x86_64

localhost login: 

```
* press 'ctrl' + ']' to come out from vm shell

* To shutdown vm

```
[host@machine ~]$ sudo virsh shutdown centos7Base
Domain centos7Base is being shutdown
```

## Set hostname for Centos7Base virtual machine

* To set hostname shutdown vm first

```
[host@machine ~]$ sudo virsh shutdown centos7Base
Domain centos7Base is being shutdown
```
* Notice that hostname is not set. Use the command below to set it

```
[host@machine ~]$  sudo virt-customize -d centos7Base --hostname centos7Base
[   0.0] Examining the guest ...
[  18.6] Setting a random seed
[  18.6] Setting the hostname: centos7Base
[  18.7] Finishing off
```

* Now check hostname  

```
[host@machine ~]$ sudo virsh start centos7Base
Domain centos7Base started

[host@machine ~]$ sudo virsh console centos7Base
Connected to domain centos7Base
Escape character is ^]

CentOS Linux 7 (Core)
Kernel 3.10.0-1062.el7.x86_64 on an x86_64

centos7Base login:                          # Hostname is change to centos7Base
```

## Login using IP address

* Login to the machine & check IP address

```
[host@machine ~]$ sudo virsh console centos7Base
Connected to domain centos7Base
Escape character is ^]

CentOS Linux 7 (Core)
Kernel 3.10.0-1062.el7.x86_64 on an x86_64

centos7Base login:  mosipuser
password: mosipuser
```

* Now check IP address( eth0) of centos7Base machine

```
[mosipuser@centos7Base ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:4d:81:14 brd ff:ff:ff:ff:ff:ff
    inet 192.168.124.248/24 brd 192.168.124.255 scope global noprefixroute dynamic eth0
       valid_lft 3248sec preferred_lft 3248sec
    inet6 fe80::5054:ff:fe4d:8114/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
* Note down the IP address "192.168.124.248". Come out of the machine. try to login using ssh.

```
[host@machine ~]$ ssh -o StrictHostKeyChecking=no mosipuser@192.168.124.248
Warning: Permanently added '192.168.124.248' (ECDSA) to the list of known hosts.
mosipuser@192.168.124.248's password: 

Last login: Sat Feb 20 15:07:00 2021
[mosipuser@centos7Base ~]$ 

```
* Check IP address using virsh command

```
[host@machine ~]$ sudo virsh net-dhcp-leases default 
 Expiry Time          MAC address        Protocol  IP address                Hostname        Client ID or DUID
-------------------------------------------------------------------------------------------------------------------
 2021-02-20 16:05:04  52:54:00:4d:81:14  ipv4      192.168.124.248/24        centos7Base     -

```

* You may have noted that this IP Address is Dynamic IP address means this ip address may change in future. 

* So we need to provide static IP address to our vm's. Because we don't want our IP address to change
  

## Provide Static IP Address to vm's

* First get "MAC address " of the vm's using the following command

```
[host@machine ~]$ virsh dumpxml centos7Base | grep mac

    <type arch='x86_64' machine='pc-q35-4.2'>hvm</type>
      <mac address='52:54:00:02:19:20'/>
```

* Copy the mac address

* Add these mac addrsses to KVM default network.

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
      <host mac='52:54:00:02:19:20' name='centos7Base' ip='192.168.122.3'/>      # like this provide 
    </dhcp>
  </ip>
</network>

# save the file
```
* Paste the mac address & provide IP address under host tag.

* Add the IP address to /etc/hosts file

```
[host@machine ~]$ sudo vim /etc/hosts

127.0.0.1       localhost
127.0.0.1       www.localhost
127.0.1.1       machine
192.168.122.3   centos7Base

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
```
```
[host@machine ~]$ virsh start centos7Base 
Domain centos7Base started
```

* Now, you can see that IP address is what we have provided in virsh net-edit default

```
[host@machine ~]$ virsh net-dhcp-leases default 
 Expiry Time           MAC address         Protocol   IP address         Hostname      Client ID or DUID
----------------------------------------------------------------------------------------------------------
 2021-02-21 19:33:00   52:54:00:02:19:20   ipv4       192.168.122.3/24   centos7Base   -
```

* Now, try to enter into centos7Base machine using SSH 

```
[host@machine ~]$ ssh mosipuser@centos7Base 

The authenticity of host 'centos7base (192.168.122.3)' can't be established.
ECDSA key fingerprint is SHA256:Fq/TVnIUBroxmOiOsFH/dqGuiXb2sKvW3A0z5KjKejo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'centos7base' (ECDSA) to the list of known hosts.
[mosipuser@centos7Base ~]$ 
```

## Setup passwordless sudoer for mosipuser

* On host machine, execute this command to make passwordless sudoer for mosipuser

```
[host@machine ~]$ sudo virt-customize -d centos7Base --run-command "echo 'mosipuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
[sudo] password for anadi: 
[   0.0] Examining the guest ...
[   3.2] Setting a random seed
[   3.3] Running: echo 'mosipuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
[   3.5] Finishing off
```

## Make centos7Base machine passwordLess SSH access

* To make passwordLess access to any vm.
* First we need get ssh public key ~/.ssh/ folder. 

```
[host@machine ~]$ cat ~/.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOf2hLNYrz/Qp32uGVr+z8+zJ2z/dlFr/cTeTJ7irisD2/qA4tHO3VdiuJXx0kP475KMnpuGM6A8qaxhOJE3JIBzoxQ9/DaIutCerM6KsEdO1YTKdDEIqB90nxOGqCEIpiNhj9vlaZdGkkNNxOXqk7HsBSK/NQDDoUCAyhqdH1nCWTIg5nEWOH5CkXfjz5AymzaXCpCi9Ia8msJHa6b+mh12j/ikJj+R+JyEdcbc/+fAm9XBvl8J+p5sp0zT1cKWdZFsOSvlKzuW+HEfzlwQDtdDrzKId4RpdgbGnsVukDio5qjgcQnb5yWa9gHRLIEx7g3u8CiBjRSFl+m3bfsGxAHCpJy56s0KuXgLirczKfm5FQ2U0dgyuS190vu/y+o5hmJ2YIIiX4vK5tKh1QP7/tzeI/ZtT3OwyHr8wZ2qKT/WWCo+2VUBTbo+C5lJ+wTSzFHw/hQFZ/WRET8XxZDxWxReAv4kXZ8OFJC4OznATlf9u76ifFoydGNysCYpV3890= host@machine
```

* If not present, generate new ssh keys using the following command:

```
[host@machine ~]$ ssh-keygen -t rsa 
```

* Copy ssh public key from ~/.ssh/id_rsa.pub file

```
[host@machine ~]$ cat ~/.ssh/id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOf2hLNYrz/Qp32uGVr+z8+zJ2z/dlFr/cTeTJ7irisD2/qA4tHO3VdiuJXx0kP475KMnpuGM6A8qaxhOJE3JIBzoxQ9/DaIutCerM6KsEdO1YTKdDEIqB90nxOGqCEIpiNhj9vlaZdGkkNNxOXqk7HsBSK/NQDDoUCAyhqdH1nCWTIg5nEWOH5CkXfjz5AymzaXCpCi9Ia8msJHa6b+mh12j/ikJj+R+JyEdcbc/+fAm9XBvl8J+p5sp0zT1cKWdZFsOSvlKzuW+HEfzlwQDtdDrzKId4RpdgbGnsVukDio5qjgcQnb5yWa9gHRLIEx7g3u8CiBjRSFl+m3bfsGxAHCpJy56s0KuXgLirczKfm5FQ2U0dgyuS190vu/y+o5hmJ2YIIiX4vK5tKh1QP7/tzeI/ZtT3OwyHr8wZ2qKT/WWCo+2VUBTbo+C5lJ+wTSzFHw/hQFZ/WRET8XxZDxWxReAv4kXZ8OFJC4OznATlf9u76ifFoydGNysCYpV3890= host@machine
```

* Add ssh key to centos7Base machine

```
# start centos7Base machine
[host@machine ~]$ virsh start centos7Base 
Domain centos7Base started
```
```
# copy ssh public key into a varibale 
[host@machine ~]$ sshKey=$(< ~/.ssh/id_rsa.pub)
[host@machine ~]$ echo $sshKey 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOf2hLNYrz/Qp32uGVr+z8+zJ2z/dlFr/cTeTJ7irisD2/qA4tHO3VdiuJXx0kP475KMnpuGM6A8qaxhOJE3JIBzoxQ9/DaIutCerM6KsEdO1YTKdDEIqB90nxOGqCEIpiNhj9vlaZdGkkNNxOXqk7HsBSK/NQDDoUCAyhqdH1nCWTIg5nEWOH5CkXfjz5AymzaXCpCi9Ia8msJHa6b+mh12j/ikJj+R+JyEdcbc/+fAm9XBvl8J+p5sp0zT1cKWdZFsOSvlKzuW+HEfzlwQDtdDrzKId4RpdgbGnsVukDio5qjgcQnb5yWa9gHRLIEx7g3u8CiBjRSFl+m3bfsGxAHCpJy56s0KuXgLirczKfm5FQ2U0dgyuS190vu/y+o5hmJ2YIIiX4vK5tKh1QP7/tzeI/ZtT3OwyHr8wZ2qKT/WWCo+2VUBTbo+C5lJ+wTSzFHw/hQFZ/WRET8XxZDxWxReAv4kXZ8OFJC4OznATlf9u76ifFoydGNysCYpV3890= host@machine
```
```
# create authorized_keys file on centos7Base
[host@machine ~]$ ssh mosipuser@centos7Base 'touch ~/.ssh/authorized_keys'

# change authorized_keys file permission to 600
[host@machine ~]$ ssh mosipuser@centos7Base 'chmod 600 ~/.ssh/authorized_keys'
```
```
# now append host ssh key to centos7Base machine
[host@machine ~]$ ssh mosipuser@centos7Base 'echo '$sshKey' >> ~/.ssh/authorized_keys'
mosipuser@centos7base's password: 
```
**Simple Method: ssh-cop-id**
* Other approach **ssh-copy-id**, which helps to add host machine ssh keys to centos7Base machine which is much simple

```
[host@machine ~]$ ssh-copy-id mosipuser@centos7Base 
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
mosipuser@centos7base's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'mosipuser@centos7Base'"
and check to make sure that only the key(s) you wanted were added.


```

# References

1. [raymii.org](https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html#toc_5)
*  [Serverfault](https://serverfault.com/questions/875367/vm-started-but-it-is-not-listed-by-virsh)
*  [computingforgeeks.com](https://computingforgeeks.com/use-virt-manager-as-non-root-user/)