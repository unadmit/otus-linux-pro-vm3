#!/bin/bash
yum install -y mdadm smartmontools hdparm gdisk xfsdump
sudo pvcreate /dev/sdb
sudo vgcreate vg_root /dev/sdb
sudo lvcreate -n lv_root -l +100%FREE /dev/vg_root
sudo mkfs.xfs /dev/vg_root/lv_root
sudo mount /dev/vg_root/lv_root /mnt
sudo xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done
sudo chroot /mnt/
lsblk
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done
sudo awk -F\' '$1=="menuentry " {print $2}' /boot/grub2/grub.cfg
sudo grub2-set-default 1