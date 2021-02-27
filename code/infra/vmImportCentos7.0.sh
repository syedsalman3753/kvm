virt-install --name CentOS_7_Server \
 --memory 2048 \
 --vcpus 1 \
 --disk ~/Documents/centos7Base-1-vmSetup.qcow2,bus=sata --import \
 --os-variant centos7.0 \
 --network default
 
 sudo virsh shutdown CentOS_7_Server
 sleep 10
 sudo virt-customize -d CentOS_7_Server --hostname CentOS_7_Server
 sudo virt-sysprep -d CentOS_7_Server --enable abrt-data,backup-files,bash-history,crash-data,cron-spool,dovecot-data,logfiles,passwd-backups,puppet-data-log,sssd-db-log,tmp-files
 
 virsh desc CentOS_7_Server upgraded from centos7Base
 virsh desc CentOS_7_Server --title centos7Base