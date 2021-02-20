# Install centos7Base Virtual MACHINE in KVM

## 1. Make A git Clone of KVM repository

* Install git on your local machine

```
$ sudo yum install git -y
```

* Goto kvm repository [link](https://github.com/123iris/kvm.git) 

```
$ cd ~
$ git clone https://github.com/123iris/kvm.git
```

## 2. Goto infra directory

```
$ cd ~/kvm/code/infra/
```

## 3. Check createVmCentos7.sh file

* This script will help you to create new centos7 OS virtual machine in KVM

```
$ ls ~/kvm/code/infra/
createVmCentos7.sh
```

## 4. Run createVmCentos7.sh

* Run createVmCentos7.sh script to install a new VM in your local machine

```
$ sudo bash createVmCentos7.sh centos7Base 2048 1 8
 
 USAGE: bash createCentos7Vm.sh vmName vmRAM(MiB) vCPU vmDiskSize(GiB) 

 This script will create a new VM 
 Do you want to continue ? (yes | no ) y

```

## 5. Post Installation Steps

* centos7Base is the VM from which every other VM is created for mosip installation.

* Follow these directions when they come up during OS installation.

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
$ sudo virsh list --all   
 Id    Name                           State
----------------------------------------------------
 2     centos7Base                    running
 3     console.sb                     Shut off
```

* List running vm's

```
$ sudo virsh list 
 Id    Name                           State
----------------------------------------------------
 2     centos7Base                    running

```

* You may have observed that we are able to access the machine only using sudo power

  Now, we need to allow non-sudo user to work with KVM 
  
* Check if this is working

```
[mosipuser@console ~]$  virsh -c qemu:///system list --all
 Id    Name                           State
----------------------------------------------------
 -     centos7Base                    shut off

```
  
* Check whether libvirt group is present or not. If not Create one.

```
[mosipuser@console ~]$ sudo getent group | grep libvirt
libvirt:x:991:
```
* If above didn't work. Some Distribution uses libvirtd. Try this if above didn't work.

```
[mosipuser@console ~]$ sudo getent group | grep libvirtd
```

* If these is no libvirt group. Create one using the following command

```
[mosipuser@console ~]$ sudo groupadd --system libvirt
groupadd: group 'libvirt' already exists
```

* Now Add user account to the libvirt group

```
sudo usermod -a -G libvirt userName

sudo usermod -a -G libvirt mosipuser
sudo usermod -a -G libvirt $(whoami)     # add for current user
```

* Check libvirt group is added to the user

```
[mosipuser@console ~]$ id $(whoami)       # for current user
uid=1000(mosipuser) gid=1000(mosipuser) groups=1000(mosipuser),991(libvirt)
```
```
[mosipuser@console ~]$ id mosipuser
uid=1000(mosipuser) gid=1000(mosipuser) groups=1000(mosipuser),991(libvirt)
```

## Check whether VM is working properly 


* Start a virtual machine using virsh command

```
$ virsh start centos7Base
Domain centos7Base started
```

* Enter into centos7Base machine

```
$ sudo virsh console centos7Base
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
$ sudo virsh shutdown centos7Base
Domain centos7Base is being shutdown
```

## Set hostname for Centos7Base virtual machine

* To set hostname shutdown vm first

```
[mosipuser@techguru ~]$ sudo virsh shutdown centos7Base
Domain centos7Base is being shutdown
```
* Notice that hostname is not set. Use the command below to set it

```
[mosipuser@techguru ~]$  sudo virt-customize -d centos7Base --hostname centos7Base
[   0.0] Examining the guest ...
[  18.6] Setting a random seed
[  18.6] Setting the hostname: centos7Base
[  18.7] Finishing off
```

* Now check hostname  

```
[mosipuser@techguru ~]$ sudo virsh start centos7Base
Domain centos7Base started

[mosipuser@techguru ~]$ sudo virsh console centos7Base
Connected to domain centos7Base
Escape character is ^]

CentOS Linux 7 (Core)
Kernel 3.10.0-1062.el7.x86_64 on an x86_64

centos7Base login:                          # Hostname is change to centos7Base
```

## Login using IP address

* Login to the machine & check IP address

```
[mosipuser@techguru ~]$ sudo virsh console centos7Base
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
[mosipuser@console ~]$ ssh -o StrictHostKeyChecking=no mosipuser@192.168.124.248
Warning: Permanently added '192.168.124.248' (ECDSA) to the list of known hosts.
mosipuser@192.168.124.248's password: 

Last login: Sat Feb 20 15:07:00 2021
[mosipuser@centos7Base ~]$ 

```
* Check IP address using virsh command

```
[mosipuser@console ~]$ sudo virsh net-dhcp-leases default 
 Expiry Time          MAC address        Protocol  IP address                Hostname        Client ID or DUID
-------------------------------------------------------------------------------------------------------------------
 2021-02-20 16:05:04  52:54:00:4d:81:14  ipv4      192.168.124.248/24        centos7Base     -

```

* You may have noted that this IP Address is Dynamic IP address means this ip address may change in future. 

  So we need to provide dynamic IP address to our vm's. 
  

## Provide Static IP Address to vm's


# References

1. [Serverfault](https://serverfault.com/questions/875367/vm-started-but-it-is-not-listed-by-virsh)
2. [computingforgeeks.com](https://computingforgeeks.com/use-virt-manager-as-non-root-user/)