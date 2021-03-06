# virsh commands cheatsheet to manage KVM guest virtual machines

* Virsh is a management user interface for virsh guest domains. Virsh can be used to create, pause, restart, and shutdown domains. In addition, virsh can be used to list current domains available in your Virtualization hypervisor platform.


* Virsh interacts with Libvirt which is a library aimed at providing a long-term stable C API. It currently supports Xen, QEMU, KVM, LXC, OpenVZ, VirtualBox and VMware ESX.

* The basic structure of most virsh usage is:

```
virsh [OPTION]... <command> <domain> [ARG]...
```

## virsh Basic commands

### 1. virsh display node information

* This is the first item on our virsh commands cheatsheet. 
* This displays the host node information and the machines that support the virtualization process.

```
[host@machine:~]$ sudo virsh  nodeinfo
CPU model:           x86_64
CPU(s):              8
CPU frequency:       2358 MHz
CPU socket(s):       1
Core(s) per socket:  4
Thread(s) per core:  2
NUMA cell(s):        1
Memory size:         16289340 KiB
```

### 2. virsh list all domains

* To list both inactive and active domains, use the command:

```
[host@machine:~]$ sudo virsh list --all
 Id    Name                           State
 ----------------------------------------------------
-     admin                          shut off
-     cloudstack                     shut off
-     hyperv                         shut off
-     ipa                            shut off
-     katello                        shut off
-     node1                          shut off
```

### 3. List only active domains

* To list only active domains with virsh command, use:

```
[host@machine:~]$ sudo virsh list
 Id    Name                           State
 ---------------------------------------------------- 
```

### 4. virsh start vm

* This is an example on how to use virsh command to start a guest virtual machine. We’re going to start centosVM domain displayed above:

```
[host@machine:~]$ virsh start centosVM
Domain centosVM started

[host@machine:~]$ virsh list      
 Id    Name                           State
-----------------------------------------------------
 3     centosVMCentos                    running 
```

### 5. virsh autostart vm

* To set a vm to start automatically on system startup, do:

```
[host@machine:~]$ sudo virsh autostart centosVM
Domain centosVM marked as autostarted

[host@machine:~]$ sudo virsh dominfo centosVM  
Id:             9
Name:           centosVM
UUID:           a943ed42-ba62-4270-a41d-7f81e793d754
OS Type:        hvm
State:          running
CPU(s):         2
CPU time:       144.6s
Max memory:     2048 KiB
Used memory:    2048 KiB
Persistent:     yes
Autostart:      enable    # This is enabled
Managed save:   no
Security model: none
Security DOI:   0
```

### 6. virsh autostart disable

* To disable autostart feature for a vm:

```
 [host@machine:~]$ virsh autostart --disable centosVM
 Domain centosVM unmarked as autostarted

 [host@machine:~]$ virsh dominfo centosVM
 Id:             -
 Name:           centosVM
 UUID:           a943ed42-ba62-4270-a41d-7f81e793d754
 OS Type:        hvm
 State:          shut off
 CPU(s):         2
 Max memory:     2048 KiB
 Used memory:    2048 KiB
 Persistent:     yes
 Autostart:      disable     # This is Disabled
 Managed save:   no
 Security model: none
 Security DOI:   0
```

### 7. virsh stop vm, virsh shutdown vm

* To shutdown a running vm gracefully use:

```
[host@machine:~]$ sudo virsh shutdown centosVM
Domain centosVM is being shutdown

[host@machine:~]$ sudo virsh list
 Id    Name                           State
----------------------------------------------------
 
```

### 8. virsh force shutdown vm

* You can do a forceful shutdown of active domain using the command:

```
[host@machine:~]$ sudo virsh destroy centosVM
```

### 9. virsh stop/shutdown all running vms

* In case you would like to shutdown all running domains, just issue the command below:

```
[host@machine:~]$ for vm in `sudo virsh list --all | grep "running" |awk 'NR>2{print [host@machine:~]$2}'`; do
	 sudo virsh shutdown [host@machine:~]$vm;
  done
```

### 10. virsh start all running vms

* In case you would like to shutdown all running domains, just issue the command below:

```
[host@machine:~]$ for vm in `sudo virsh list --all | grep "shut off" |awk 'NR>2{print [host@machine:~]$2}'`; do
	 sudo virsh start [host@machine:~]$vm;
  done
```

### 11. virsh reboot vm

* To restart a vm named centosVM, the command used is:

```
[host@machine:~]$ sudo virsh reboot centosVM
```

### 12. virsh remove vm

* To cleanly remove a vm including its storage columes, use the commands shown below.
* The domain centosVM should be replaced with the actual domain to be removed.

```
[host@machine:~]$ sudo virsh destroy centosVM 2> /dev/null
[host@machine:~]$ sudo virsh undefine  centosVM
[host@machine:~]$ sudo virsh pool-refresh default
[host@machine:~]$ sudo virsh vol-delete --pool default centosVM.qcow2
In this example, storage volume is named /var/lib/libvirt/images/centosVM.qcow2
```

### 13. virsh create a vm

* If you would like to create a new virtual machine with virsh, the relevant command to use is `virt-install. 
* This is crucial and can’t miss on virsh commands cheatsheet arsenal. 
* The example below will install a new operating system from CentOS 7 ISO Image.

```
[host@machine:~]$ sudo virt-install \
--name centos7 \
--description "centosVM VM with CentOS 7" \
--ram=1024 \
--vcpus=2 \
--os-type=Linux \
--os-variant=rhel7 \
--disk path=/var/lib/libvirt/images/centos7.qcow2,bus=virtio,size=10 \
--graphics none \
--location [host@machine:~]$HOME/iso/CentOS-7-x86_64-Everything-1611.iso \
--network bridge:virbr0  \
--console pty,target_type=serial -x 'console=ttyS0,115200n8 serial'
```

### 14. virsh connect to vm console


* To connect to the guest console, use the command:

```
[host@machine:~]$ sudo virsh console centosVM
Connected to domain centosVM
Escape character is ^]

### Press enter
```
This will return a fail message if an active console session exists for the provided domain. 

### 15. Virsh edit vm xml file
 
* To edit a vm xml file, use:

```
# To  use vim text editor

[host@machine:~]$ sudo EDITOR=vim virsh edit centosVM 

# To use nano text editor

[host@machine:~]$ sudo EDITOR=nano virsh edit centosVM
```


### 16. virsh suspend vm, virsh resume vm

* To suspend a guest called centosVM with virsh command, run:

```
[host@machine:~]$ sudo virsh suspend centosVM
Domain centosVM suspended
```
NOTE: When a domain is in a suspended state, it still consumes system RAM. Disk and network I/O will not occur while the guest is suspended.

### 17. Resuming a guest vm:

* To restore a suspended guest with virsh using the resume option:

```
[host@machine:~]$ sudo virsh resume centosVM
Domain centosVM resumed
```

### 18. virsh save vm

* To save the current state of a vm to a file using the virsh command :

```
[host@machine:~]$ sudo virsh save centosVM /home/kvmUser/centosVM.saved
Domain centosVM saved to centosVM.save

[host@machine:~]$ ls -l centosVM.save 
-rw------- 1 root root 328645215 Mar 18 01:35 centosVM.saved
```

### 19. Restoring a saved vm

* To restore saved vm from the file:

```
[host@machine:~]$ virsh restore /home/kvmUser/centosVM.save 
Domain restored from centosVM.save

[host@machine:~]$ sudo virsh list
 Id    Name                           State
 ----------------------------------------------------
  7    centosVM                           running
```

## virsh Manage Volumes

* Here we’ll cover how to create a storage volume , attach it to a vm , detach it from a vm and how to delete a volume.

### 1. virsh create volume

* To create a 2GB volume named centosVM_vol2 on the default storage pool, use:

```
[host@machine:~]$ sudo virsh vol-create-as default  centosVM_vol2.qcow2  2G
Vol centosVM_vol2.qcow2 created

[host@machine:~]$ sudo du -sh /var/lib/libvirt/images/centosVM_vol2.qcow2
2.0G/var/lib/libvirt/images/centosVM_vol2.qcow2
```
default: Is the pool name.

centosVM_vol2: This is the name of the volume.

2G: This is the storage capacity of the volume.



### 2. virsh attach a volume to vm

* To attach created volume above to vm centosVM, run:

```
[host@machine:~]$ sudo virsh attach-disk --domain centosVM \
--source /var/lib/libvirt/images/centosVM_vol2.qcow2  \
--persistent --target vdb

Disk attached successfully
```

--persistent: Make live change persistent
--target vdb: Target of a disk device

You can confirm that the volume was added to the vm as a block device /dev/vdb

```
[host@machine:~]$ ssh root@centosVM
Last login: Fri Mar 17 19:30:54 2017 from gateway

[root@centosVM ~]# lsblk --output NAME,SIZE,TYPE
NAME                    SIZE   TYPE
sr0                     1024M  rom
vda                     10G    disk
├─vda1                  1G     part
└─vda2                  9G     part
  ├─cl_centosVM-root        8G     lvm
    └─cl_centosVM-swap      1G     lvm
    vdb                 2G     disk
```

### 3. virsh detach volume on vm

* To detach above volume centosVM_vol2 from the vm centosVM:

```
[host@machine:~]$ sudo virsh detach-disk --domain centosVM --persistent --live --target vdb
Disk detached successfully

[host@machine:~]$ ssh centosVM
Last login: Sat Mar 18 01:52:33 2017 from gateway
[root@centosVM ~]# 
[root@centosVM ~]# lsblk --output NAME,SIZE,TYPE
NAME                    SIZE   TYPE
sr0                     1024M  rom
vda                     10G    disk
├─vda1                  1G     part
└─vda2                  9G     part
  ├─cl_centosVM-root        8G     lvm
    └─cl_centosVM-swap      1G     lvm
```
You can indeed confirm from this output that the device /dev/vdb has been detached


### 4. To Increase vm volume (i.e qcow2 image)

* Please note that you can directly grow disk image for the vm using qemu-img command, this will look something like this:

* List vm Image path

```
[host@machine:~]$ virsh vol-list  --pool default
 Name                   Path
----------------------------------------------------------------------
cloudstack.qcow2     /var/lib/libvirt/images/cloudstack.qcow2
ipa.qcow2            /var/lib/libvirt/images/ipa.qcow2       
katello.qcow2        /var/lib/libvirt/images/katello.qcow2   
node1.qcow2          /var/lib/libvirt/images/node1.qcow2     
node2.qcow2          /var/lib/libvirt/images/node2.qcow2     
node3.qcow2          /var/lib/libvirt/images/node3.qcow2     
centosVM.qcow2           /var/lib/libvirt/images/centosVM.qcow2 
```

* Resize vm volume image

```
[host@machine:~]$ sudo qemu-img resize /var/lib/libvirt/images/centosVM.qcow2 +1G
```

### 5. virsh delete volume

* To delete volume with virsh command, use:

```
[host@machine:~]$ sudo virsh vol-delete centosVM.qcow2  --pool default
Vol centosVM_vol2.qcow2 deleted

[host@machine:~]$ sudo virsh pool-refresh  default
Pool default refreshed

[host@machine:~]$ sudo virsh vol-list default
 Name                 Path                                    
 ------------------------------------------------------------------------------
admin.qcow2          /var/lib/libvirt/images/admin.qcow2     
cloudstack.qcow2     /var/lib/libvirt/images/cloudstack.qcow2
ipa.qcow2            /var/lib/libvirt/images/ipa.qcow2       
katello.qcow2        /var/lib/libvirt/images/katello.qcow2   
node1.qcow2          /var/lib/libvirt/images/node1.qcow2     
node2.qcow2          /var/lib/libvirt/images/node2.qcow2     
node3.qcow2          /var/lib/libvirt/images/node3.qcow2            
```

#TODO: 
## virsh Manage Snapshots



# References

1. [computingforgeeks.com](https://computingforgeeks.com/virsh-commands-cheatsheet/)