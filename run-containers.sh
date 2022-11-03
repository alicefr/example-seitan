#!/bin/bash 

set -x

if [ -z $1 ]; then
	"Missing the scsi disk"
	exit 1
fi
DISK=$1

docker rm -f pr-helper
docker rm -f qemu

docker run -ti -d --name pr-helper \
  -w  /usr/local/seitan/ \
  --pid host \
  --network host \
  --privileged \
  pr-helper

docker run --name qemu --security-opt label=disable \
  --device ${DISK}:/dev/sdb \
  --device /dev/kvm:/dev/kvm \
  -w /usr/local/bin \
  -u root:kvm -tid \
  qemu  -cpu host \
        -enable-kvm \
        -display none \
        -serial stdio \
        -nodefaults \
        -m 1024 \
        -device virtio-scsi \
        -object pr-manager-helper,id=helper0,path=/var/run/qemu-pr-helper.sock \
        -blockdev node-name=hd,driver=raw,file.driver=host_device,file.filename=/dev/sdb,file.pr-manager=helper0 \
        -device scsi-block,drive=hd \
        -hda /disk/disk.img

pid=$(docker inspect --format "{{.State.Pid}}" qemu)

docker exec -ti pr-helper ./seitan $pid
