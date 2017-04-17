## Toolbox for cdxvirt platform
sshd port 2222, password is ``!Q@W3e4r``.

# Toolbox container build & run
```
docker build -t cdxvirt/toolbox .
docker run --name toolbox --privileged --net=host -v /var/run/docker.sock:/var/run/docker.sock -t -d cdxvirt/toolbox
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
