#!/bin/bash
CLUSTER_ID="${1:-k8sup-cluster}"
NETWORK="${2:-192.168.32.0/23}"
K8S_VERSION="${3:-k8s-1.5}"

docker run -d \
    --privileged \
    --net=host \
    --pid=host \
    --restart=always \
    -v $(which docker):/bin/docker:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/:/host/lib:ro \
    -v /usr/sbin/modprobe:/usr/sbin/modprobe:ro \
    -v /opt/bin:/opt/bin:rw \
    -v /lib/modules:/lib/modules:ro \
    -v /etc/cni:/etc/cni \
    -v /var/lib/cni:/var/lib/cni \
    -v /var/lib/etcd:/var/lib/etcd \
    -v /var/lib/kubelet:/var/lib/kubelet \
    -v /etc/kubernetes:/etc/kubernetes \
    --name=k8sup \
    cdxvirt/k8sup:${K8S_VERSION} \
    --cluster=${CLUSTER_ID} \
    --network=${NETWORK}
