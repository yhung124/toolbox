FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server vim python parted gdisk
RUN mkdir /var/run/sshd
RUN echo 'root:!Q@W3e4r' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/^Port.*/Port 2222/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir -m 700 /root/.ssh
RUN mkdir -p /opt
ADD bin /opt/bin
ENV PATH /opt/bin:$PATH
ADD README.md /README.md

ADD sshd_config /etc/ssh/sshd_config

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D"]
