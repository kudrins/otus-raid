#!/bin/bash
#
# создать RAID 5 
#
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
sudo mdadm --create --verbose /dev/md0 -l 5 -n 5 /dev/sd{b,c,d,e,f}
#
# создать mdadm.conf
#
sudo mkdir /etc/mdadm
sudo touch /etc/mdadm/ndadm.conf
sudo cdmod 666 /etc/mdadm/mdadm.conf
sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
sudo cdmod 664 /etc/mdadm/mdadm.conf
#
# создать GPT-таблицу, раздел, смонтировать
#
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/md0p1
sudo mkdir -p /mnt/md0p1
sudo mount /dev/md0p1/ /mnt/md0p1
#
# записать в /etc/fstab
#
sudo echo `blkid /dev/md0p1 | awk '{print$2}' | sed -e 's/"//g'` /mnt/md0p1 ext4 defaults,noatime 0 2 >> /etc/fstab