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

