# Create a Ubuntu 20.10 Virtual machine in KVM

## 1. git clone kvm repo

* Install git on your local machine

```
[host@machine ~]$ sudo yum install git -y
```

* Goto kvm repository [link](https://github.com/123iris/kvm.git) 

```
[host@machine ~]$ cd ~
[host@machine ~]$ git clone https://github.com/123iris/kvm.git 
````

* Goto code/infra/1-createVms/createVmUbuntu/1-createVms directory

```
[host@machine ~]$ cd ~/Documentation/kvm/code/infra/1-createVms/createVmUbuntu/1-createVms
```

## 2. Check for createVmUbuntu20.10.sh file

```
[host@machine 1-createVms]$ ls
createVmUbuntu20.10.sh  createVmUbuntu18.04.sh
```

## 3. Update osinfo query db

* ubuntu20.10 has not been present in osinfo-db. So, we need to follow below steps to add lastest xml fiile to our osinfo-db.

  (Which is used in os-varient in kvm virt-install ) 

* Install osinfo-db-tools

```
[host@machine ~]$ sudo apt install osinfo-db-tools -y
```

* Download latest osinfo-db zip file from https://releases.pagure.org/libosinfo/

```
[host@machine ~]$ wget -O "/tmp/osinfo-db.tar.xz"  https://releases.pagure.org/libosinfo/osinfo-db-20210202.tar.xz
```

* Import the osinfo-db zip file to upgrade osinfo-query

```
[host@machine ~]$ sudo osinfo-db-import --local "/tmp/osinfo-db.tar.xz"
```

* Check whether Ubuntu 20.10 is xml file exists or not 

```
[host@machine ~]$ osinfo-query os | grep -i ubuntu | cut -d ' ' -f -2
 ubuntu10.04
 ubuntu10.10
 ....
 ....
 ubuntu20.04
 ubuntu20.10     # Ubuntu 20.10 version xml file has beed added to our  osinfo-db 
 ubuntu4.10
 ....
 ....
 ubuntu9.10
```
## 3. Run createVmUbuntu20.10.sh file

* Run createVmUbuntu20.10.sh script to install a new VM in your local machine

```
[host@machine 1-createVms]$ bash createVmUbuntu20.04.sh ubuntu20Base 4096 3 32
 
 USAGE: bash createUbuntu20.10.sh vmName vmRAM(MiB) vCPU vmDiskSize(GiB) 

 This script will create a new Ubuntu VM 
 Do you want to continue ? (yes | no ) y
```

## 4. Select English

* Use arrows, and & enter to select 

```
  ┌───────────────────────┤ [!!] Select a language ├────────────────────────┐
  │                                                                         │
  │ Choose the language to be used for the installation process. The        │
  │ selected language will also be the default language for the installed   │
  │ system.                                                                 │
  │                                                                         │
  │ Language:                                                               │
  │                                                                         │
  │                               C                                         │
  │                               C.UTF-8                                   │
  │                               English  # select English                                 │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
<Tab> moves; <Space> selects; <Enter> activates buttons
```

## 5. Select location

* Use arrows, and & enter to select 

```
  ┌──────────────────────┤ [!!] Select your location ├──────────────────────┐
  │                                                                         │
  │ The selected location will be used to set your time zone and also for   │
  │ example to help select the system locale. Normally this should be the   │
  │ country where you live.                                                 │
  │                                                                         │
  │ This is a shortlist of locations based on the language you selected.    │
  │ Choose "other" if your location is not listed.                          │
  │                                                                         │
  │ Country, territory or area:                                             │
  │                                                                         │
  │                         Hong Kong                                       │
  │                         India                   # India                         │
  │                         Ireland              ▒                          │
  │                         Israel               ▒                          │
  │                         New Zealand          ▒                          │
  │                         Nigeria                                         │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

## 6. Select Keyboard configuration

* Select 'NO'

```
    ┌───────────────────┤ [!] Configure the keyboard ├────────────────────┐
    │                                                                     │
    │ You can try to have your keyboard layout detected by pressing a     │
    │ series of keys. If you do not want to do this, you will be able to  │
    │ select your keyboard layout from a list.                            │
    │                                                                     │
    │ Detect keyboard layout?                                             │
    │                                                                     │
    │     <Go Back>                                     <Yes>    <No>     │
    │                                                          (select NO)│
    └─────────────────────────────────────────────────────────────────────┘
```

* Select US english

```
  ┌─────────────────────┤ [!] Configure the keyboard ├──────────────────────┐
  │                                                                         │
  │ The layout of keyboards varies per country, with some countries         │
  │ having multiple common layouts. Please select the country of origin     │
  │ for the keyboard of this computer.                                      │
  │                                                                         │
  │ Country of origin for the keyboard:                                     │
  │                                                                         │
  │              Dutch                                                      │
  │              Dzongkha                                   ▒               │
  │              English (Australian)                                       │
  │              English (Cameroon)                         ▒               │
  │              English (Ghana)                            ▒               │
  │              English (Nigeria)                          ▒               │
  │              English (South Africa)                     ▒               │
  │              English (UK)                               ▒               │
  │              English (US)    # Select US english                        │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

* Select English US & Press enter

```
  ┌─────────────────────┤ [!] Configure the keyboard ├──────────────────────┐
  │                                                                         │
  │ Please select the layout matching the keyboard for this machine.        │
  │                                                                         │
  │ Keyboard layout:                                                        │
  │                                                                         │
  │  English (US)  # Select US ENGLISH                                      │
  │  English (US) - Cherokee                                                │
  │  English (US) - English (Colemak)                                   ▒   │
  │  English (US) - English (Dvorak)                                    ▒   │
  │  English (US) - English (Dvorak, alt. intl.)                        ▒   │
  │  English (US) - English (Dvorak, intl., with dead keys)             ▒   │
  │  English (US) - English (Dvorak, left-handed)                       ▒   │
  │  English (US) - English (Dvorak, right-handed)                      ▒   │
  │  English (US) - English (Macintosh)                                 ▒   │
  │  English (US) - English (Norman)                                    ▒   │
  │  English (US) - English (US, alt. intl.)                                │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

## 7. Select network configuration

* Provided **hostname** localhost & press on continue/Enter

```
   ┌─────────────────────┤ [!] Configure the network ├─────────────────────┐
   │                                                                       │
   │ Please enter the hostname for this system.                            │
   │                                                                       │
   │ The hostname is a single word that identifies your system to the      │
   │ network. If you don't know what your hostname should be, consult your │
   │ network administrator. If you are setting up your own home network,   │
   │ you can make something up here.                                       │
   │                                                                       │
   │ Hostname:                                                             │
   │                                                                       │
   │ localhost____________________________________________________________ │
   │                                                                       │
   │     <Go Back>                                          <Continue>     │
   │                                                                       │
   └───────────────────────────────────────────────────────────────────────┘
```

## 8. Choose a mirror of the Ubuntu archive

* Select "enter information manually" & press Enter

```
  ┌──────────────┤ [!] Choose a mirror of the Ubuntu archive ├──────────────┐
  │                                                                         │
  │ The goal is to find a mirror of the Ubuntu archive that is close to     │
  │ you on the network -- be aware that nearby countries, or even your      │
  │ own, may not be the best choice.                                        │
  │                                                                         │
  │ Ubuntu archive mirror country:                                          │
  │                                                                         │
  │             enter information manually     ### select                   │
  │             Afghanistan                                                 │
  │             Albania                                       ▒             │
  │             Algeria                                       ▒             │
  │             American Samoa                                ▒             │
  │             Andorra                                       ▒             │
  │             Angola                                        ▒             │
  │             Anguilla                                      ▒             │
  │             Antarctica                                                  │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
<Tab> moves; <Space> selects; <Enter> activates buttons
```
* Choose mirror server from url `http://mirrors.ubuntu.com/mirrors.txt`
  ```
  host@machine $ curl mirrors.ubuntu.com/mirrors.txt
  
  https://mirrors.nxtgen.com/ubuntu-mirror/ubuntu/
  http://ftp.iitm.ac.in/ubuntu/
  http://ubuntu.hbcse.tifr.res.in/ubuntu/
  https://repo.extreme-ix.org/ubuntu/
  https://in.mirror.coganng.com/ubuntu/
  http://mirrors.piconets.webwerks.in/ubuntu-mirror/ubuntu/
  http://repos.del.extreme-ix.org/ubuntu/
  https://in.mirror.coganng.com/ubuntu-ports/
  http://archive.ubuntu.com/ubuntu/         ## selected this mirror
  ```
* Check if mirror is "in.archive.ubuntu.com" & Press enter

```
     ┌───────────┤ [!!] Choose a mirror of the Ubuntu archive ├───────────┐
     │                                                                    │
     │ Please enter the hostname of the mirror from which Ubuntu will be  │
     │ downloaded.                                                        │
     │                                                                    │
     │ An alternate port can be specified using the standard              │
     │ [hostname]:[port] format.                                          │
     │                                                                    │
     │ Ubuntu archive mirror hostname:                                    │
     │                                                                    │
     │ archive.ubuntu.com________________________________________________ │
     │                                                                    │
     │     <Go Back>                                       <Continue>     │
     │                                                        (Select)    │
     └────────────────────────────────────────────────────────────────────┘

<Tab> moves; <Space> selects; <Enter> activates buttons
```

* Select url path `/ubuntu` from mirror url `http://archive.ubuntu.com/ubuntu/`.
  ```
   ┌────────────┤ [!!] Choose a mirror of the Ubuntu archive ├─────────────┐
   │                                                                       │
   │ Please enter the directory in which the mirror of the Ubuntu archive  │
   │ is located.                                                           │
   │                                                                       │
   │ Ubuntu archive mirror directory:                                      │
   │                                                                       │
   │ /ubuntu/_____________________________________________________________ │
   │                                                                       │
   │     <Go Back>                                          <Continue>     │
   │                                                         (Select)      │
   └───────────────────────────────────────────────────────────────────────┘
  <Tab> moves; <Space> selects; <Enter> activates buttons
  ```

* Leave it blank & press Enter

```
    ┌────────────┤ [!] Choose a mirror of the Ubuntu archive ├────────────┐
    │                                                                     │
    │ If you need to use a HTTP proxy to access the outside world, enter  │
    │ the proxy information here. Otherwise, leave this blank.            │
    │                                                                     │
    │ The proxy information should be given in the standard form of       │
    │ "http://[[user][:pass]@]host[:port]/".                              │
    │                                                                     │
    │ HTTP proxy information (blank for none):                            │
    │                                                                     │
    │ ___________________________________________________________________ │
    │                                                                     │
    │     <Go Back>                                        <Continue>     │
    │                                                       (Select)      │
    └─────────────────────────────────────────────────────────────────────┘
```

Please wait till download is complete.
```
  ┌────────────────────┤ Loading additional components ├────────────────────┐
  │                                                                         │
  │                                   10%                                   │
  │|_|_|_|_|_|_|_\_|______________________________________________________  │
  │ Retrieving firewire-core-modules-5.4.0-26-generic-di                    │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

## 9. Set up users and passwords

* Provide "mosipuser" & password "mosipuser".

```

   ┌──────────────────┤ [!!] Set up users and passwords ├──────────────────┐
   │                                                                       │
   │ A user account will be created for you to use instead of the root     │
   │ account for non-administrative activities.                            │
   │                                                                       │
   │ Please enter the real name of this user. This information will be     │
   │ used for instance as default origin for emails sent by this user as   │
   │ well as any program which displays or uses the user's real name. Your │
   │ full name is a reasonable choice.                                     │
   │                                                                       │
   │ Full name for the new user:                                           │
   │                                                                       │
   │ mosipuser____________________________________________________________ │
   │                                                                       │
   │     <Go Back>                                          <Continue>     │
   │                                                                       │
   └───────────────────────────────────────────────────────────────────────┘
```

* Provide password for mosipuser i.e Password="mosipuser"

```
      ┌───────────────┤ [!!] Set up users and passwords ├───────────────┐
      │                                                                 │
      │ A good password will contain a mixture of letters, numbers and  │
      │ punctuation and should be changed at regular intervals.         │
      │                                                                 │
      │ Choose a password for the new user:                             │
      │                                                                 │
      │ mosipuser______________________________________________________ │
      │                                                                 │
      │ [ ] Show Password in Clear                                      │
      │                                                                 │
      │     <Go Back>                                    <Continue>     │
      │                                                                 │
      └─────────────────────────────────────────────────────────────────┘
```

## 10. Configure the clock

* Check if time-zone is correct (Asia/Kolkata). If not change it

```
   ┌──────────────────────┤ [!] Configure the clock ├──────────────────────┐
   │                                                                       │
   │ Based on your present physical location, your time zone is            │
   │ Asia/Kolkata.                                                         │
   │                                                                       │
   │ If this is not correct, you may select from a full list of time zones │
   │ instead.                                                              │
   │                                                                       │
   │ Is this time zone correct?                                            │
   │                                                                       │
   │     <Go Back>                                       <Yes>    <No>     │
   │                                                    (Select)           │
   └───────────────────────────────────────────────────────────────────────┘
```
## 11. Partition disks

* Select "Guided - use entire disk and set up LVM" for partitions

```
  ┌────────────────────────┤ [!!] Partition disks ├─────────────────────────┐
  │                                                                         │
  │ The installer can guide you through partitioning a disk (using          │
  │ different standard schemes) or, if you prefer, you can do it            │
  │ manually. With guided partitioning you will still have a chance later   │
  │ to review and customise the results.                                    │
  │                                                                         │
  │ If you choose guided partitioning for an entire disk, you will next     │
  │ be asked which disk should be used.                                     │
  │                                                                         │
  │ Partitioning method:                                                    │
  │                                                                         │
  │          Guided - use entire disk                                       │
  │          Guided - use entire disk and set up LVM    # Select this       │
  │          Guided - use entire disk and set up encrypted LVM              │
  │          Manual                                                         │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

* Press Enter

```
  ┌────────────────────────┤ [!!] Partition disks ├─────────────────────────┐
  │                                                                         │
  │ Note that all data on the disk you select will be erased, but not       │
  │ before you have confirmed that you really want to make the changes.     │
  │                                                                         │
  │ Select disk to partition:                                               │
  │                                                                         │
  │   Virtual disk 1 (vda) - 17.2 GB Virtio Block Device  # Select & Enter  │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

* Select Yes to configure the disk partition

```
   ┌───────────────────────┤ [!!] Partition disks ├────────────────────────┐
   │                                                                       │
   │ Before the Logical Volume Manager can be configured, the current      │
   │ partitioning scheme has to be written to disk. These changes cannot   │
   │ be undone.                                                            │
   │                                                                       │
   │ After the Logical Volume Manager is configured, no additional changes │
   │ to the partitioning scheme of disks containing physical volumes are   │
   │ allowed during the installation. Please decide if you are satisfied   │
   │ with the current partitioning scheme before continuing.               │
   │                                                                       │
   │ The partition tables of the following devices are changed:            │
   │    Virtual disk 1 (vda)                                               │
   │                                                                       │
   │ Write the changes to disks and configure LVM?                         │
   │                                                                       │
   │     <Yes>                                                    <No>     │
   │   (Select)                                                            │
   └───────────────────────────────────────────────────────────────────────┘
```

* Press Enter

```
  ┌─────────────────────────┤ [!] Partition disks ├─────────────────────────┐
  │                                                                         │
  │ You may use the whole volume group for guided partitioning, or part     │
  │ of it. If you use only part of it, or if you add more disks later,      │
  │ then you will be able to grow logical volumes later using the LVM       │
  │ tools, so using a smaller part of the volume group at installation      │
  │ time may offer more flexibility.                                        │
  │                                                                         │
  │ The minimum size of the selected partitioning recipe is 1.9 GB (or      │
  │ 11%); please note that the packages you choose to install may require   │
  │ more space than this. The maximum available size is 33.8 GB.            │
  │                                                                         │
  │ Hint: "max" can be used as a shortcut to specify the maximum size, or   │
  │ enter a percentage (e.g. "20%") to use that percentage of the maximum   │
  │ size.                                                                   │
  │                                                                         │
  │ 33.8 GB______________________________________________________________   │
  │                                                                         │
  │     <Go Back>                                            <Continue>     │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

* Select 'Yes' to select these partitions listed below & Press Enter

```
    ┌───────────────────────┤ [!!] Partition disks ├───────────────────────┐
    │                                                                      │
    │ If you continue, the changes listed below will be written to the     │
    │ disks. Otherwise, you will be able to make further changes manually. │
    │                                                                      │
    │ The partition tables of the following devices are changed:           │
    │    LVM VG vglocalhost, LV root                                       │
    │    LVM VG vglocalhost, LV swap_1                                     │
    │                                                                      │
    │ The following partitions are going to be formatted:                  │
    │    LVM VG vglocalhost, LV root as ext4                               │
    │    LVM VG vglocalhost, LV swap_1 as swap                             │
    │    partition #1 of Virtual disk 1 (vda) as                           │
    │                                                                      │
    │ Write the changes to disks?                                          │
    │                                                                      │
    │     <Yes>                                                   <No>     │
    │    (Select)                                                          │
    └──────────────────────────────────────────────────────────────────────┘
```

Please wait till "Installing the base system" complete

## 12. Select "No automatic updates" 

* "No automatic updates" & Press Enter

```
  ┌────────────────────────┤ [!] PAM configuration ├────────────────────────┐
  │                                                                         │
  │ Applying updates on a frequent basis is an important part of keeping    │
  │ your system secure.                                                     │
  │                                                                         │
  │ By default, updates need to be applied manually using package           │
  │ management tools. Alternatively, you can choose to have this system     │
  │ automatically download and install security updates, or you can         │
  │ choose to manage this system over the web as part of a group of         │
  │ systems using Canonical's Landscape service.                            │
  │                                                                         │
  │ How do you want to manage upgrades on this system?                      │
  │                                                                         │
  │                No automatic updates      # Select this                  │
  │                Install security updates automatically                   │
  │                Manage system with Landscape                             │
  │                                                                         │
  │     <Go Back>                                                           │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

## 13. Software Selection

* Select OpenSSH server, Basic Ubuntu Server

```
  ┌───────────────────────┤ [!] Software selection ├────────────────────────┐
  │                                                                         │
  │ At the moment, only the core of the system is installed. To tune the    │
  │ system to your needs, you can choose to install one or more of the      │
  │ following predefined collections of software.                           │
  │                                                                         │
  │ Choose software to install:                                             │
  │                                                                         │
  │               [ ] Large selection of font packages                      │
  │               [ ] 2D/3D creation and editing suite        ▒             │
  │               [ ] Photograph touchup and editing suite    ▒             │
  │               [ ] Publishing applications                 ▒             │
  │               [ ] Video creation and editing suite        ▒             │
  │               [ ] Xubuntu minimal installation            ▒             │
  │               [ ] Xubuntu desktop                         ▒             │
  │               [ ] OpenSSH server                                        │
  │               [ ] Basic Ubuntu server                                   │
  │                                                                         │
  │     <Go Back>                                            <Continue>     │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```

* Use space to select & Press Continue. Star(*) indicates its selected 

```
  ┌───────────────────────┤ [!] Software selection ├────────────────────────┐
  │                                                                         │
  │ At the moment, only the core of the system is installed. To tune the    │
  │ system to your needs, you can choose to install one or more of the      │
  │ following predefined collections of software.                           │
  │                                                                         │
  │ Choose software to install:                                             │
  │                                                                         │
  │               [ ] Large selection of font packages                      │
  │               [ ] 2D/3D creation and editing suite        ▒             │
  │               [ ] Photograph touchup and editing suite    ▒             │
  │               [ ] Publishing applications                 ▒             │
  │               [ ] Video creation and editing suite        ▒             │
  │               [ ] Xubuntu minimal installation            ▒             │
  │               [ ] Xubuntu desktop                         ▒             │
  │        # This [*] OpenSSH server                                        │
  │        # This [*] Basic Ubuntu server                                   │
  │                                                                         │
  │     <Go Back>                                            <Continue>     │
  │                                                                         │
  └─────────────────────────────────────────────────────────────────────────┘
```
Please wait till installation completes

## 14. Install the GRUB boot loader on a hard disk

* Select 'yes' to Install the GRUB boot loader on a hard disk & press Enter

```
    ┌─────────┤ [!] Install the GRUB boot loader on a hard disk ├──────────┐
    │                                                                      │
    │ It seems that this new installation is the only operating system on  │
    │ this computer. If so, it should be safe to install the GRUB boot     │
  ┌─│ loader to the master boot record of your first hard drive.           │
  │ │                                                                      │
  │ │ Warning: If the installer failed to detect another operating system  │
  │ │ that is present on your computer, modifying the master boot record   │
  │ │ will make that operating system temporarily unbootable, though GRUB  │
  │ │ can be manually configured later to boot it.                         │
  └─│                                                                      │
    │ Install the GRUB boot loader to the master boot record?              │
    │                                                                      │
    │     <Go Back>                                      <Yes>    <No>     │
    │                                                   (Select)           │
    └──────────────────────────────────────────────────────────────────────┘

```

## 15. Select UTC System clock

* Select 'Yes' to Set UTC system clock

```
   ┌────────────────────┤ [!] Finish the installation ├────────────────────┐
   │                                                                       │
  ┌│ System clocks are generally set to Coordinated Universal Time (UTC).  │
  ││ The operating system uses your time zone to convert system time into  │
  ││ local time. This is recommended unless you also use another operating │
  ││ system that expects the clock to be set to local time.                │
  ││                                                                       │
  ││ Is the system clock set to UTC?                                       │
  └│                                                                       │
   │     <Go Back>                                       <Yes>    <No>     │
   │                                                    (Select)           │
   └───────────────────────────────────────────────────────────────────────
```

## 16. Installation complete

* After successful Installation. Press Enter to reboot vm

```
   ┌───────────────────┤ [!!] Finish the installation ├────────────────────┐
   │                                                                       │
  ┌│                         Installation complete                         │
  ││ Installation is complete, so it is time to boot into your new system. │
  ││ Make sure to remove the installation media (CD-ROM, floppies), so     │
  ││ that you boot into the new system rather than restarting the          │
  ││ installation.                                                         │
  ││                                                                       │
  └│     <Go Back>                                          <Continue>     │
   │                                                        (Select)       │
   └───────────────────────────────────────────────────────────────────────┘
```

## 17. Post Installation 

* **Not able to Enter vm using virsh console vmName**

* After successfull installation

```
Domain creation completed.
Restarting guest.
Connected to domain ubuntu20Base
Escape character is ^]
							# Enter not Working 
```

* Overcome this problem login using ssh 

```
[host@machine ~]$ virsh net-dhcp-leases default 
 Expiry Time           MAC address         Protocol   IP address          Hostname   Client ID or DUID
-----------------------------------------------------------------------------------------------------------------------------------------------
 2021-03-07 14:27:32   52:54:00:29:4b:e5   ipv4       192.168.122.81/24   -          ff:56:50:4d:98:00:02:00:00:ab:11:46:5f:ee:bf:4d:30:be:14
```

* Login Using ssh using IP address

```
[host@machine ~]$ ssh mosipuser@192.168.122.81

The authenticity of host '192.168.122.81 (192.168.122.81)' can't be established.
ECDSA key fingerprint is SHA256:JGi9w9KX9o26g7XUuKLectS8FhA8UdaVZgvUyHwPV8A.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.122.81' (ECDSA) to the list of known hosts.

mosipuser@192.168.122.81's password:  mosipuser
```

* Start & Enable tty service 

```
[mosipuser@localhost:~]$ sudo systemctl enable serial-getty@ttyS0.service
[sudo] password for mosipuser: 
Created symlink /etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service → /lib/systemd/system/serial-getty@.service.

[mosipuser@localhost:~]$ sudo systemctl start serial-getty@ttyS0.service

```

* To logout from vm type 'exit'

```
[mosipuser@localhost:~]$ exit
logout

CentOS Linux 7 (Core)
Kernel 3.10.0-1160.11.1.el7.x86_64 on an x86_64

localhost login: 
* Now try to login using virsh console command & Press Enter to get login option
```

* press 'ctrl' + ']' to come out from vm shell

```
[host@machine ~]$ virsh console ubuntu20Base 
Connected to domain ubuntu20Base
Escape character is ^]             # Press Enter to get login option
```
```
localhost login: mosipuser
Password: mosipuser

mosipuser@localhost:~$
```

## 18. Change Hostname for ubuntu20Base Virtual Machine

* To set hostname shutdown vm first

```
[host@machine:~]$ virsh shutdown ubuntu20Base 
Domain ubuntu20Base is being shutdown
```

* Set hostname

```
[host@machine:~]$ sudo virt-customize -d ubuntu20Base --hostname ubuntu20Base
[   0.0] Examining the guest ...
[   7.0] Setting a random seed
[   7.1] Setting the hostname: ubuntu20Base
[   8.2] Finishing off
```

* Start & login to check hostname

```
[host@machine:~]$ virsh start ubuntu20Base 
Domain ubuntu20Base started

[host@machine:~]$ virsh console ubuntu20Base 
Connected to domain ubuntu20Base
Escape character is ^]             # press Enter 2-3 times to get login 

Ubuntu 20.04.2 LTS ubuntu20Base ttyS0

ubuntu20Base login: mosipuser            # hostname change from localhost
Password: 
```

## 19. Verify IP address

* Start & login to check hostname

```
[host@machine:~]$ virsh start ubuntu20Base 
Domain ubuntu20Base started

[host@machine:~]$ virsh console ubuntu20Base 
Connected to domain ubuntu20Base
Escape character is ^]             # press Enter 2-3 times to get login 

Ubuntu 20.04.2 LTS ubuntu20Base ttyS0

ubuntu20Base login: mosipuser            # hostname change from localhost
Password: 
```

* Check IP address like this "192.168.122.81"

```
mosipuser@ubuntu20Base:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:29:4b:e5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.81/24 brd 192.168.122.255 scope global dynamic enp1s0    # This is IP addressI
       valid_lft 3510sec preferred_lft 3510sec
    inet6 fe80::5054:ff:fe29:4be5/64 scope link 
       valid_lft forever preferred_lft forever

```
* Verify at Host Machine side

```
[host@machine:~]$ virsh net-dhcp-leases default 
 Expiry Time           MAC address         Protocol   IP address          Hostname       Client ID or DUID
---------------------------------------------------------------------------------------------------------------------------------------------------
 2021-03-07 15:19:05   52:54:00:29:4b:e5   ipv4       192.168.122.81/24   ubuntu20Base   ff:56:50:4d:98:00:02:00:00:ab:11:46:5f:ee:bf:4d:30:be:14

```

## 20. Provide Static IP to ubuntu20Base machine

* Shutdown ubuntu20Base machine

```
[host@machine:~]$ virsh shutdown ubuntu20Base 
Domain ubuntu20Base is being shutdown
```

* First get "MAC address " of the vm's using the following command

```
[host@machine:~]$ virsh dumpxml ubuntu20Base | grep "mac address"
      <mac address='52:54:00:29:4b:e5'/>
```

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
      <host mac='52:54:00:54:01:af' name='centos7Base' ip='192.168.122.3'/>
      <host mac='52:54:00:44:ef:2d' name='centos78Base' ip='192.168.122.4'/>
      ....
      ....
      <host mac='52:54:00:29:4b:e5' name='ubuntu20Base' ip='192.168.122.13'/>    # Like this
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
....
....
192.168.122.13  ubuntu20Base     # like this

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
 Id   Name             State
---------------------------------
 -    centos78Base     shut off
 -    centos7Base      shut off
....
....
 -    ubuntu20Base     shut off
```

* Start ubuntu20Base machine

```
[host@machine ~]$ virsh start ubuntu20Base 
Domain ubuntu20Base started
```

* Now, you can see that IP address is what we have provided in virsh net-edit default

```
[host@machine ~]$ virsh net-dhcp-leases default 
 Expiry Time           MAC address         Protocol   IP address          Hostname       Client ID or DUID
---------------------------------------------------------------------------------------------------------------------------------------------------
 2021-03-07 16:43:32   52:54:00:29:4b:e5   ipv4       192.168.122.13/24   ubuntu20Base   ff:56:50:4d:98:00:02:00:00:ab:11:46:5f:ee:bf:4d:30:be:14
 
```

* Now, try to enter into ubuntu20Base machine using SSH

```
[host@machine ~]$ ssh mosipuser@ubuntu20Base 

Warning: Permanently added 'ubuntu20base' (ECDSA) to the list of known hosts.
Warning: the ECDSA host key for 'ubuntu20base' differs from the key for the IP address '192.168.122.13'
Offending key for IP in /home/host/.ssh/known_hosts:35
mosipuser@ubuntu20base's password: 

Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-66-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sunday 07 March 2021 03:46:49 PM IST

  System load:  0.02               Processes:               141
  Usage of /:   14.6% of 14.21GB   Users logged in:         0
  Memory usage: 5%                 IPv4 address for enp1s0: 192.168.122.13
  Swap usage:   0%


0 updates can be installed immediately.
0 of these updates are security updates.


Last login: Sun Mar  7 14:19:19 2021
mosipuser@ubuntu20Base:~$ 

```

## 21. Setup passwordless sudoer for mosipuser

* On host machine, execute this command to make passwordless sudoer for mosipuser

```
# shutdown ubuntu20Base machine 
[host@machine ~]$ virsh shutdown ubuntu20Base 
Domain ubuntu20Base is being shutdown
```
* Now run below command to make passwordLess sudoer for mosipuser

```
[host@machine ~]$ sudo virt-customize -d ubuntu20Base --run-command "echo 'mosipuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

[   0.0] Examining the guest ...
[   2.8] Setting a random seed
[   2.8] Running: echo 'mosipuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
[   2.9] Finishing off
```

## 22. Make ubuntu20Base machine passwordLess SSH access

* On host machine run below command to make password less ssh login

```
[host@machine ~]$ ssh-copy-id mosipuser@ubuntu20Base 
The authenticity of host 'ubuntu20base (192.168.122.13)' can't be established.
ECDSA key fingerprint is SHA256:JGi9w9KX9o26g7XUuKLectS8FhA8UdaVZgvUyHwPV8A.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
mosipuser@ubuntu20base's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'mosipuser@ubuntu20Base'"
and check to make sure that only the key(s) you wanted were added.

```

* Now test passwordLess ssh login 

```
[host@machine ~]$ ssh mosipuser@ubuntu20Base 
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-66-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sunday 07 March 2021 03:54:08 PM IST

  System load:  0.12               Processes:               145
  Usage of /:   14.6% of 14.21GB   Users logged in:         0
  Memory usage: 5%                 IPv4 address for enp1s0: 192.168.122.13
  Swap usage:   0%


0 updates can be installed immediately.
0 of these updates are security updates.


Last login: Sun Mar  7 15:46:49 2021 from 192.168.122.1
mosipuser@ubuntu20Base:~$

```
* Check Ubuntu version

```
mosipuser@ubuntu20Base:~$  lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.2 LTS
Release:	20.04
Codename:	focal
```

## ALLOW ROOT SSH LOGIN 

* login as non-root user on ubuntu VM's
* open sshd_config file, and add this "PermitRootLogin yes" in a new line

```
mosipuser@ubuntu20Base:~$ sudo vim /etc/ssh/sshd_config
....
....
PermitRootLogin yes
...
...
```

* restart sshd service

```
mosipuser@ubuntu20Base:~$ sudo systemctl restart sshd
```

* Now try to login as root via ssh

```
techno-384@techno384-Latitude-3410:~/Documents/GIT/kvm/code/infra/1-createVms/createVmUbuntu/1-createVms$ ssh root@ubuntu20Base 
root@ubuntu20base's password: 
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-84-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

root@ubuntu20Base:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:6d:2c:93 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.4/24 brd 192.168.122.255 scope global dynamic enp1s0
       valid_lft 3391sec preferred_lft 3391sec
    inet6 fe80::5054:ff:fe6d:2c93/64 scope link 
       valid_lft forever preferred_lft forever
root@ubuntu20Base:~# exit
logout
Connection to ubuntu20base closed.
```

## update ubuntu20Base epackages
* run `sudo apt-get update --fix-missing -y` to update packages.
* 
# Reference

1. [askubuntu.com](https://askubuntu.com/questions/1070500/why-doesnt-osinfo-query-os-detect-ubuntu-18-04)
*  [jp.archive.ubuntu.com](http://jp.archive.ubuntu.com/ubuntu/dists/groovy/main/installer-amd64/)
*  [blog.eldernode.com](https://blog.eldernode.com/enable-root-login-via-ssh-in-ubuntu-20-04/)
