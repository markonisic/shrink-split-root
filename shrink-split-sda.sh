#!/bin/bash
df -Ph | grep '/dev/vda2' | awk {'print $5'} | while read output;
do
  echo $output
  used=$(echo $output | awk '{print $1}' | sed s/%//g)
  partition=$(echo $output | awk '{print $2}')
  if [ $used -le 45 ]; then
  (echo d;echo 2;echo n;echo 2;echo ;echo +30G;echo w) | sudo fdisk /dev/vda
  (echo n;echo 3;echo ;echo ;echo w) | sudo fdisk /dev/vda
  sudo partprobe /dev/vda2
  sudo resize2fs /dev/vda2
  sudo mkfs.ext4 /dev/vda3
  sudo mkdir -p /mnt/vda3
  sudo mount /dev/vda3 /mnt/vda3
  echo "/dev/vda3 /mnt/vda3 ext4 defaults 0 0" >> /etc/fstab
  fi
done
