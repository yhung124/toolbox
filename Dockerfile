FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server vim python parted gdisk
RUN mkdir /var/run/sshd
RUN echo 'root:!Q@W3e4r' | chpasswd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -m 700 /root/.ssh
RUN mkdir -p /opt
ADD bin /opt/bin
ENV PATH /opt/bin:$PATH
ADD README.md /README.md

RUN rm -f /etc/ssh/sshd_config
ADD sshd_config /etc/ssh/sshd_config

RUN echo "alias docker='LD_LIBRARY_PATH=$(dirname $(find /lib -iname libdl.so.2)):/host/lib docker'" >> /root/.bashrc

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D"]
