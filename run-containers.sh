#!/bin/bash 

set -x

DISK=${DISK:-/dev/sdb}

docker rm -f pr-helper
docker rm -f qemu

docker run -ti -d --name pr-helper \
  --entrypoint /bin/bash \
  --pid host \
  --network host \
  --privileged \
  pr-helper

docker run --name qemu --security-opt label=disable \
	--entrypoint /bin/bash \
	--device ${DISK}:/dev/sdb \
	--device /dev/kvm:/dev/kvm \
	-u root:kvm -td qemu
