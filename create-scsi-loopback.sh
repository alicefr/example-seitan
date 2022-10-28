#!/bin/bash -x

sudo modprobe tcm_loop
sudo mount -t configfs configfs /sys/kernel/config/
sudo 
sudo mkdir -p /disks
sudo targetcli backstores/fileio create disk1 /disks/disk.img 1G
sudo targetcli loopback/ create 50014051998a423d
sudo targetcli loopback/naa.50014051998a423d/luns create /backstores/fileio/disk1
lsblk --scsi
