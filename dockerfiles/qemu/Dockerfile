FROM disk as builder
FROM seitan as seitan
FROM fedora:36

RUN dnf install -y qemu-system-x86-core strace && dnf clean all

RUN mkdir /usr/local/pflaume
COPY --from=builder /disk/disk.img /disk/disk.img
COPY ./seitan/seitan-loader /usr/local/bin/seitan-loader
COPY ./seitan/bpf.out  /usr/local/bin/bpf.out
RUN mkdir -p /home/qemu && chown qemu:kvm -R /home/qemu
ENTRYPOINT ["/usr/local/bin/seitan-loader"]

