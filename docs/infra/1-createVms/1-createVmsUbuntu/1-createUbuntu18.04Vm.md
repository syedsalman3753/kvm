# References

## virsh console vmName : Enter not working 

* After successful Ubuntu installation not able to login in vm due to enter not accepting 

```
$ virsh console ubuntu20Base --safe
Connected to domain ubuntu14Base
Escape character is ^]
------------------#  Enter not working
```

* To overcome this use IP address to login into the machine. After that start serial-getty@ttyS0 service on ubuntu vm 

```
[host@machine:~]$ $ virsh net-dhcp-leases default 
 Expiry Time           MAC address         Protocol   IP address           Hostname   Client ID or DUID
---------------------------------------------------------------------------------------------------------
 2021-03-06 20:04:15   52:54:00:63:93:b6   ipv4       192.168.122.122/24   ubuntu     -

```
```
[host@machine:~]$ ssh mosipuser@192.168.122.122  # ip of ubuntu vm
password: mosipuser
mosipuser@ubuntu:/home/mosipuser# sudo systemctl enable serial-getty@ttyS0.service
Created symlink /etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service → /lib/systemd/system/serial-getty@.service.

mosipuser@ubuntu:/home/mosipuser# sudo systemctl start serial-getty@ttyS0.service
```
1. [www.server-world.info](https://www.server-world.info/en/note?os=Ubuntu_18.04&p=kvm&f=2)
*  [serverfault.com/](https://serverfault.com/questions/364895/virsh-vm-console-does-not-show-any-output)
*  [archive.ubuntu.com](http://jp.archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/)