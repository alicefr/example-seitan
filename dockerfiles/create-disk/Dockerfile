FROM fedora:35 as builder

ENV LIBGUESTFS_BACKEND direct
ENV IMAGE https://download.fedoraproject.org/pub/fedora/linux/releases/35/Cloud/x86_64/images/Fedora-Cloud-Base-35-1.2.x86_64.qcow2

RUN dnf install -y libguestfs guestfs-tools curl

# Cache image download for the next steps
RUN curl -L -o /disk.img ${IMAGE}

RUN virt-customize -a /disk.img --install sg3_utils

RUN virt-customize -a /disk.img \
      --root-password password:test \
      --run-command 'useradd -m  fedora -s /bin/bash' \
      --run-command 'echo "fedora ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/fedora' \
      --password  'fedora:password:fedora' \
      --run-command "sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config" \
      --run-command "dnf clean all -y" 

RUN virt-sparsify --in-place /disk.img

FROM scratch
COPY --from=builder /disk.img /disk/disk.img
