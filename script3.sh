#!/bin/bash
sudo cat /etc/fstab
sudo lvremove -y /dev/vg_root/lv_root
sudo vgremove -y /dev/vg_root
sudo pvremove -y /dev/sdb
sudo lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
sudo mkfs.xfs /dev/VolGroup00/LogVol_Home
sudo mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
sudo umount /mnt
sudo mount /dev/VolGroup00/LogVol_Home /home/
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" | sudo tee -a /etc/fstab
sudo touch /home/file{1..20}
ls -la /home/
sudo lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
sudo rm -f /home/file{11..20}
ls -la /home/
cd /etc && sudo umount /home
sudo lvconvert --merge /dev/VolGroup00/home_snap
ls -la /home/

sudo pvcreate /dev/sde
sudo vgcreate vg_test /dev/sde
sudo lvcreate -n lv_test -L 500M vg_test
sudo mkfs.xfs /dev/vg_test/lv_test
sudo mkdir /test
echo "`sudo blkid | grep test | awk '{print $2}'` /test xfs noexec 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo cp /bin/cat /test/
sudo /test/cat
ls -la /test/