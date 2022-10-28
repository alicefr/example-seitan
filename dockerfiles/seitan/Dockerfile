FROM fedora:36 

RUN dnf install gcc git make -y
RUN git clone git://seitan.rocks/seitan \
    && cd seitan \
    && make
