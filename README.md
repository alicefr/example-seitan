# Example with seitan and the SCSI persistent reservation

This repository contains a self-contained example to try [seitan](https://seitan.rocks/seitan/about/) and the SCSI persistent reservation using QEMU and the [qemu-pr-helper daemon](https://qemu.readthedocs.io/en/latest/tools/qemu-pr-helper.html).

## How to run the example

Create a SCSI loopback device using `targetcli`:
```bash
$ ./create-scsi-loopback.sh
```
Launch the containers:
  + `pr-helper` contains the `qemu-pr-helper` and `seitan`
  + `qemu` contains`QEMU`, the VM disk image and the `seitan-loader`

```bash
$ ./run-containers.sh /dev/sdb
+ docker run -ti -d --name pr-helper -w /usr/local/seitan/ --pid host --network host --privileged pr-helper
5546984063c4a579fef7075ef4bad1631276dd3a9ad9e6b8661715949eef18a3
+ docker run --name qemu --security-opt label=disable --device /dev/sdb:/dev/sdb --device /dev/kvm:/dev/kvm -w /usr/local/bin -u root:kvm -tid qemu -cpu host -enable-kvm -display none -serial stdio -nodefaults -m 1024 -device virtio-scsi -object pr-manager-helper,id=helper0,path=/var/run/qemu-pr-helper.sock -blockdev node-name=hd,driver=raw,file.driver=host_device,file.filename=/dev/sdb,file.pr-manager=helper0 -device scsi-block,drive=hd -hda /disk/disk.img
c6097f6e791fbab120cce284361a379d59733635d3e9c323bdf7f729d6fa3a7a
++ docker inspect --format '{{.State.Pid}}' qemu
+ pid=190485
+ docker exec -td pr-helper ./seitan 190485
```

You can attach to the `qemu` container and log into the guest to try the scsi reservation:
``` bash
$ docker attach qemu 
fedora login: root
Password: 
[root@fedora ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0    5G  0 disk 
├─sda1   8:1    0    1M  0 part 
├─sda2   8:2    0  500M  0 part /boot
├─sda3   8:3    0  100M  0 part /boot/efi
├─sda4   8:4    0    4M  0 part 
└─sda5   8:5    0  4.4G  0 part /home
                                /
sdb      8:16   0    1G  0 disk 
[root@fedora ~] sg_persist -i -k /dev/sdb
  LIO-ORG   disk1             4.0 
  Peripheral device type: disk
  PR generation=0x0, there are NO registered reservation keys
[root@fedora ~]  sg_persist -o -G  --param-sark=12345678 /dev/sdb
  LIO-ORG   disk1             4.0 
  Peripheral device type: disk
[root@fedora ~] sg_persist -i -k /dev/sdb
  LIO-ORG   disk1             4.0 
  Peripheral device type: disk
  PR generation=0x1, 1 registered reservation key follows:
    0x12345678
```
For a full example on the SCSI persistent reservation check [this example](https://gist.github.com/alicefr/c2e4221d7c8834a2b8746d510692d86c).
