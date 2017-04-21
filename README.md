## Toolbox for cdxvirt platform
sshd port 2222, password is ``!Q@W3e4r``.

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

**clean all OSD disks**
```
wipe-osd-disks.sh
```
**start k8sup**
```
k8s-start.sh {{ cluster_id }} {{ network }} {{ k8s_version }}
ex. k8s-start.sh cdxvirt-cluster 192.168.0.0/24 k8s-1.5
```
**stop k8sup**
```
k8s-stop.sh
```
**purge k8sup**
```
k8s-purge.sh
```
**nic bonding
```
nic-bonding.sh {{ NIC1 }} {{ NIC2 }} [IP/Prefix]
ex. nic-bonding.sh enp3s0 enp4s0 192.168.33.100/23
```
** run docker command
```
LD_LIBRARY_PATH=/lib/x86_64-linux-gnu/:/host/lib docker ps
```
