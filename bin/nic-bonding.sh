#!/bin/bash
NIC1="${1}"
NIC2="${2}"
IPCIDR="${3}"

if [ -z $NIC1 ] || [ -z $NIC2 ];then
  echo "Usage: $0 <NIC1> <NIC2> [IP/prefix]"
fi

# Create bonding.conf for mounting bond module
cat<<EOF > /etc/modprobe.d/bonding.conf
# Prevent kernel from automatically creating bond0 when the module is loaded.
# This allows systemd-networkd to create and apply options to bond0.
options bonding max_bonds=0 miimon=100
EOF

# Create systemd network config files
cat<<EOF > /etc/systemd/network/10-bond-nics.network
[Match]
Name=${NIC1} ${NIC2}

[Network]
Bond=bond0
EOF

cat<<EOF > /etc/systemd/network/20-bond.netdev
[NetDev]
Name=bond0
Kind=bond

[Bond]
Mode=balance-alb
EOF

if [ ! -z ${IPCIDR} ]; then
cat<<EOF > /etc/systemd/network/30-bond-static.network
[Match]
Name=bond0

[Network]
Address=${IPCIDR}
EOF
fi
