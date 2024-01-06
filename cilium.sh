#!/bin/sh

set -x

helm uninstall cilium -n kube-system

kubectl -n kube-system rollout restart ds/cilium

kubectl -n kube-system rollout restart deployment coredns

helm upgrade cilium cilium/cilium \
--version 1.14.5 \
--namespace kube-system \
--reuse-values \

--set ipam.operator.clusterPoolIPv4PodCIDRList=["10.210.55.10/24"] \
--set ipv4NativeRoutingCIDR=10.210.0.0/16 \

--set routingMode=native \
--set kubeProxyReplacement=true \
--set loadBalancer.mode=dsr \
--set tunnel=disabled


#--set ipam.operator.clusterPoolIPv4PodCIDRList=["10.42.0.0/16"] \
#--set ipv4NativeRoutingCIDR=10.42.0.0/16 \
--set ipv4.enabled=true

helm install cilium cilium/cilium --version 1.14.5 \
-n kube-system \
--set tunnel=disabled \
--set hubble.enabled=true \
--set hubble.ui.enabled=true \
--set hubble.relay.enabled=true \
--set hubble.relay.service.type=NodePort \
--set hubble.relay.service.nodePort=31234 \
--set hubble.ui.service.type=NodePort \
--set hubble.ui.service.nodePort=31235 \
--set kubeProxyReplacement=true \
--set ipv4.enabled=true \
--set ipam.operator.clusterPoolIPv4PodCIDRList=["10.210.55.10/24"] \
--set kubeProxyReplacementHealthzBindAddr='0.0.0.0:10256' \
--set ipv4NativeRoutingCIDR=10.210.0.0/16 \
--set routingMode=native \
--set loadBalancer.mode=dsr \
#--set devices=eth+ \
--set sctp.enabled=true \
--set bandwidthManager.enabled=true \
--set bandwidthManager.bbr=true

# DSR 直接服务器返回带 IPv4 选项/IPv6 扩展标头
# 带 IPv4 选项/IPv6 扩展标头是服务 IP/端口信息通过特定于 Cilium 的 IPv4 选项或 IPv6 目标选项扩展标头传输到后端。它要求 Cilium 部署在 Native-Routing 中，即它不能在封装模式下工作
--set routingMode=native \
--set kubeProxyReplacement=true \
--set loadBalancer.mode=dsr \

# NodePort 设备、端口和绑定设置
# https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#nodeport-devices-port-and-bind-settings
--set devices=eth+ # 此参数存疑

--set sctp.enabled=true \

--set externalIPs.enabled=true \

--set ipam.operator.clusterPoolIPv4PodCIDRList=["10.42.0.0/16"] \
--set ipv4NativeRoutingCIDR=10.42.0.0/16 \
--set ipv4.enabled=true \

--set kubeProxyReplacement=true \

curl 10.105.89.67:80
curl 192.168.2.100:30813
curl 10.96.101.242:30813
helm upgrade cilium cilium/cilium \
--version 1.14.5 \
--namespace kube-system \
--reuse-values \
--set kubeProxyReplacement=true \
--set socketLB.enabled=true \
--set nodePort.enabled=true \
--set externalIPs.enabled=true \
--set hostPort.enabled=true \
--set k8sServiceHost=192.168.2.155 \
--set k8sServicePort=6443 \
--set hubble.enabled=true \
--set hubble.ui.enabled=true \
--set hubble.relay.enabled=true \
--set hubble.relay.service.type=NodePort \
--set hubble.relay.service.nodePort=31234 \
--set hubble.ui.service.type=NodePort \
--set hubble.ui.service.nodePort=31235 \
--set sctp.enabled=true \
--set bandwidthManager.enabled=true \
--set bandwidthManager.bbr=true \

cilium install  \
     --set kubeProxyReplacement=true \
     --set hubble.enabled=true \
     --set nodeinit.enabled=true \
     --set routingMode=native \
     --set tunnel=disabled \
     --set k8sClientRateLimit.qps=30 \
     --set k8sClientRateLimit.burst=40 \
     --set rollOutCiliumPods=true \
     --set bpfClockProbe=true \
     --set bpf.masquerade=true \
     --set bpf.preallocateMaps=true \
     --set bpf.tproxy=true \
     --set bpf.hostLegacyRouting=false \
     --set autoDirectNodeRoutes=true \
     --set localRedirectPolicy=true \
     --set enableCiliumEndpointSlice=true \
     --set enableK8sEventHandover=true \
     --set externalIPs.enabled=true \
     --set hostPort.enabled=true \
     --set socketLB.enabled=true \
     --set nodePort.enabled=true \
     --set sessionAffinity=true \
     --set annotateK8sNode=true \
     --set nat46x64Gateway.enabled=false \
     --set pmtuDiscovery.enabled=true \
     --set enableIPv6BIGTCP=false \
     --set sctp.enabled=true \
     --set wellKnownIdentities.enabled=true \
     --set installNoConntrackIptablesRules=true \
     --set enableIPv4BIGTCP=true \
     --set egressGateway.enabled=false \
     --set endpointRoutes.enabled=false \
     --set loadBalancer.mode=dsr \
     --set loadBalancer.serviceTopology=true \
     --set highScaleIPcache.enabled=false \
     --set l2announcements.enabled=false \
     --set image.useDigest=false \
     --set operator.image.useDigest=false \
     --set operator.rollOutPods=true \
     --set authentication.enabled=false \
     --set bandwidthManager.enabled=true \
     --set bandwidthManager.bbr=true \
     --set ipv4NativeRoutingCIDR=10.244.0.0/16 \
     --set ipv6.enabled=false \
     --set ipam.mode=kubernetes \
     --set ipam.operator.clusterPoolIPv4PodCIDRList=["10.244.0.0/16"] \

--set annotateK8sNode=true  # 在初始化时使用Cilium的元数据注释Kubernetes节点
--set autoDirectNodeRoutes=true  # 如果所有节点共享单个L2网络，则自动插入节点路由
--set bandwidthManager.bbr=true  # 启用BBR拥塞控制算法的带宽管理器
--set bandwidthManager.enabled=true  # 启用带宽管理器
--set bpf.hostLegacyRouting=false  # 禁用BPF主机遗留路由
--set bpf.masquerade=true  # 启用BPF伪装
--set bpf.preallocateMaps=true  # 预分配BPF映射
--set bpf.tproxy=true  # 启用BPF透明代理
--set bpfClockProbe=true  # 启用BPF时钟探测
--set egressGateway.enabled=false  # 禁用出口网关
--set enableCiliumEndpointSlice=true  # 启用Cilium EndpointSlice
--set enableIPv4BIGTCP=true  # 启用IPv4 BIGTCP
--set enableIPv6BIGTCP=false  # 禁用IPv6 BIGTCP
--set enableK8sEventHandover=true  # 启用Kubernetes事件移交
--set endpointRoutes.enabled=false  # 禁用端点路由
--set externalIPs.enabled=true  # 启用外部IP
--set hubble.enabled=true  # 启用Hubble
--set hostPort.enabled=true  # 启用主机端口
--set image.useDigest=false  # 禁用使用摘要的镜像
--set installNoConntrackIptablesRules=true  # 安装无连接跟踪iptables规则
--set ipv4NativeRoutingCIDR=10.244.0.0/16  # IPv4本地路由CIDR
--set ipv6.enabled=false  # 禁用IPv6
--set k8sClientRateLimit.burst=40  # Kubernetes客户端速率限制突发值
--set k8sClientRateLimit.qps=30  # Kubernetes客户端速率限制QPS
--set l2announcements.enabled=false  # 禁用L2通告
--set loadBalancer.mode=dsr  # 设置负载均衡器模式为DSR
--set loadBalancer.serviceTopology=true  # 启用负载均衡器服务拓扑
--set localRedirectPolicy=true  # 启用本地重定向策略
--set nat46x64Gateway.enabled=false  # 禁用NAT46x64网关
--set nodePort.enabled=true  # 启用节点端口
--set nodeinit.enabled=true  # 启用节点初始化
--set operator.image.useDigest=false  # 禁用使用摘要的操作员镜像
--set operator.rollOutPods=true  # 操作员滚动Pods
--set rollOutCiliumPods=true  # 滚动Cilium Pods
--set routingMode=native  # 设置路由模式为本地
--set sessionAffinity=true  # 启用会话亲和性
--set sctp.enabled=true  # 启用SCTP
--set socketLB.enabled=true  # 启用Socket负载均衡
--set wellKnownIdentities.enabled=true  # 启用已知身份


     这个参数是使用node 节点分配的子网
ipam (IP Address Management), 选择 Cilium 的 IP 管理策略，支持如下选择：
- cluster-pool 默认的IP管理策略，会为每个节点分配一段 CIDR，然后分配 IP 时从这个节点的子网中选择IP，但是不如 calico 一点的是，这并不是动态分配的 IP 池，每个节点的 IP 之后不会自动补充新的 CIDR 进去
- **crd **用户手动通过 CRD 定义每个节点可用的 IP 池，方便扩展开发，自定义IP管理策略
- kubernetes 从 k8s v1.Node 对象的 podCIDR 字段读取可用 IP 池，不再自己维护 IP 池，在 1.11 使用 cilium 自己集成的 BGP Speaker 宣告 CIDR 时就只支持这种模式
- alibabacloud, azure, eni 各大公有云自己定制的 ipam 插件

set +x
