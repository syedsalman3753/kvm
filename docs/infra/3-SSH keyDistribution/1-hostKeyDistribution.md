# SSH Key Distribution Setup

## Host SSH Key Distribution Setup

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

## Test Host SSH key Distribution 

* To test whether all vm's have ssh passwordLess access from host machine execute the following script 

```
[host@machine infra]$ bash testHostKeyDistro.sh hostList 
 
 USAGE: bash testHostKeyDistro2.sh mosipVm.list 
 
 This script perform host machine is able to login to all vm's without password 
 Do you want to continue ? (yes | no ) y

 Host Key Distribution test Successfully executed !!!
```

## SSH Key Distribution  

* console.sb & mosipBaseLocal machine passwordLess access to all vm's specified in input file

```
[host@machine infra]$ bash keyDistro2.sh mosip.list mosipuser
 
 USAGE: bash keyDistro2.sh vmlistFilename userName

 This script will make baseLocal and console machine have passwordLess access to all vm's end with .sb 
 Do you wants to continue ? (yes | no ) y

 Do wants to use mosipBaseLocal as BaseLocal machine ? (yes | no )  y
 mosipBaseLocal machine is now a BaseLocal machine  

 Do wants to use console.sb as console machine ? (yes | no ) y
```

## Test SSH key Distribution

* To Test whether console.sb & mosipBaseLocal machine have passwordLess access to all vm's specified in input file

```
[host@machine infra]$ bash testkeyDistro2.sh mosip.list mosipuser

 USAGE: bash testkeyDistro2.sh vmlistFilename userName 

 This script perform a test to check whether baseLocal and console machine able to login to all vm's end with .sb without password 
 Do you wants to continue ? (yes | no ) y

```