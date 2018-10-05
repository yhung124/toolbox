FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV ANSIBLE_VER 2.4.3

RUN apt-get update && apt-get install -y \
    openssh-server \
    vim \
    python \
    parted \
    gdisk \
    cgpt \
    iproute \
    kexec-tools \
    jq \
    rsync \
    dstat \
    fio \
    lshw \
    iperf3 \
    sshpass \
    libaio1 \
    net-tools \
    curl \
    iputils-ping \
    python-netaddr \
    python-pip \
    e2fsprogs \
    && pip install ansible==$ANSIBLE_VER \
    && apt-get remove -y python-pip g++ g++-5 gcc gcc-5 cpp cpp-5 binutils build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -m 700 /root/.ssh
RUN mkdir -p /opt/bin
ENV PATH /opt/bin:$PATH
ADD README.md /README.md

RUN rm -f /etc/ssh/sshd_config
ADD sshd_config /etc/ssh/sshd_config

RUN echo "alias docker='LD_LIBRARY_PATH=$(dirname $(find $(readlink -f /lib) -iname libdl.so.2)):/host/lib docker'" >> /root/.bashrc

# Regenerating host key of sshd
RUN rm -rf /etc/ssh/ssh_host*
RUN ssh-keygen -q -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
RUN ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -q -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
RUN ssh-keygen -q -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

WORKDIR "/opt/bin"
EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D"]
