FROM fedora:36

RUN dnf install -y qemu-pr-helper && dnf clean all
RUN mkdir /usr/local/seitan
COPY dockerfiles/pr-helper/multipath.conf /etc/multipath.conf
COPY --from=seitan /seitan/seitan /usr/local/seitan/seitan
COPY --from=seitan /seitan/t.out /usr/local/seitan/t.out
COPY dockerfiles/pr-helper/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
