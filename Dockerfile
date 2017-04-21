FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server vim python docker.io parted
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

# Regenerating host key of sshd
RUN rm -rf /etc/ssh/ssh_host*
RUN ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D"]
