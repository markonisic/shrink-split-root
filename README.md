**shrink-split-sda**
&nbsp;
&nbsp;
Bash script which shrinks the asigned hdd partition/s on a GNU/Linux with fdisk utility,

splits the partition and creates a new partition from the remaining free space, formats it and mounts it.
&nbsp;
&nbsp;

/dev/vda partition in the script is used as an example and shrinked to 30 GB.

Script will only run if less than 45% or equal of the partition space is used.
&nbsp;
&nbsp;
I use this script when I have 2 or more servers deployed and need to partition the HDDs.
&nbsp;
This script is mostly suited for VMs deployed from a VM template or Cloud image and where the partition table info is known in front.
&nbsp;
&nbsp;
How it works:
&nbsp;
&nbsp;
\-\-\- First loop from bellow gathers the partition info which is assigned right by grep tool

and prints the used disk space in percentage.
&nbsp;
&nbsp;
`#!/bin/bash`

`df -Ph | grep '/dev/vda2' | awk {'print $5'} | while read output; `

`do`

`  echo $output`

`  used=$(echo $output | awk '{print $1}' | sed s/%//g)`

`  partition=$(echo $output | awk '{print $2}')`
&nbsp;
&nbsp;
\-\-\- Second loop checks for the used disk space and if less than 45% or egual of disk space is used

then it starts the fdisk utility. `Fdisk` will run two times, first time it deletes the partition table,

creates the new partition and shrinks the assigned partition to 30 GB(this values is used as na example).

On second run, fdisk creates a new partition and allocates all the remaining free space to the new partition.

All changes to the partition table are written.
&nbsp;
&nbsp;
`if [ $used -le 45 ]; then`

`(echo d;echo 2;echo n;echo 2;echo ;echo +30G;echo w) | sudo fdisk /dev/vda`

`(echo n;echo 3;echo ;echo ;echo w) | sudo fdisk /dev/vda`
&nbsp;
&nbsp;
\-\-\- The remaining lines of the script run partprobe to update the Kernel on the partition table change,

runs resize on the shrinked partition and formats the new partition.

After that, the new partition is mounted to the mount point and permanently on fstab.
&nbsp;
&nbsp;
`sudo partprobe /dev/vda2`

`sudo resize2fs /dev/vda2`

`sudo mkfs.ext4 /dev/vda3`

`sudo mkdir -p /mnt/vda3`

`sudo mount /dev/vda3 /mnt/vda3`

`echo "/dev/vda3 /mnt/vda3 ext4 defaults 0 0" >> /etc/fstab`

`fi`

`done`
