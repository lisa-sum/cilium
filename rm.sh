#!/bin/sh

rm -rf /etc/cni/net.d/05-cilium.conflist

ifconfig cilium_netdown
ip link delete kube-cilium_netdown

ifconfig cilium_host down
ip link delete cilium_host

ifconfig cilium_vxlan down
ip link delete cilium_vxlan
