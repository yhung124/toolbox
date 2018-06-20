## Toolbox for cdxvirt platform
sshd port 2222, default no password.

# Toolbox container build & run
```
docker build -t cdxvirt/toolbox .
docker run --name toolbox --privileged --net=host \
-v $(which docker):/bin/docker:ro \
-v /usr/lib/:/host/lib:ro \
-v /run/systemd:/run/systemd \
-v /etc/modprobe.d/:/etc/modprobe.d/ \
-v /etc/systemd/network/:/etc/systemd/network/
-v /var/run/docker.sock:/var/run/docker.sock -t -d cdxvirt/toolbox
```

** run docker command
```
LD_LIBRARY_PATH=$(dirname $(find /lib -iname libdl.so.2)):/host/lib docker ps
```
