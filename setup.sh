#!/bin/bash

# Namespaces oluşturma
sudo ip netns add client1
sudo ip netns add client2
sudo ip netns add server
sudo ip netns add firewall

# Virtual ethernet pairs oluşturma ve namespaces ile ilişkilendirme
sudo ip link add veth-client1 type veth peer name veth-client1-fw
sudo ip link set veth-client1 netns client1
sudo ip link set veth-client1-fw netns firewall

sudo ip link add veth-client2 type veth peer name veth-client2-fw
sudo ip link set veth-client2 netns client2
sudo ip link set veth-client2-fw netns firewall

sudo ip link add veth-server type veth peer name veth-server-fw
sudo ip link set veth-server-fw netns firewall
sudo ip link set veth-server netns server

# IP adreslerini atama, arabirimleri aktifleştirme ve gateway ayarlama
sudo ip netns exec client1 ip addr add 192.0.2.1/26 dev veth-client1
sudo ip netns exec client2 ip addr add 192.0.2.65/26 dev veth-client2
sudo ip netns exec server ip addr add 192.0.2.129/26 dev veth-server
sudo ip netns exec client1 ip link set veth-client1 up
sudo ip netns exec client2 ip link set veth-client2 up
sudo ip netns exec server ip link set veth-server up

sudo ip netns exec firewall ip addr add 192.0.2.2/26 dev veth-client1-fw
sudo ip netns exec firewall ip addr add 192.0.2.66/26 dev veth-client2-fw
sudo ip netns exec firewall ip addr add 192.0.2.130/26 dev veth-server-fw
sudo ip netns exec firewall ip link set veth-client1-fw up
sudo ip netns exec firewall ip link set veth-client2-fw up
sudo ip netns exec firewall ip link set veth-server-fw up

# Host ve Firewall arasında Veth çifti oluşturma
sudo ip link add veth-host-fw type veth peer name veth-fw-host
sudo ip link set veth-fw-host netns firewall
sudo ip -n firewall link set veth-fw-host up
sudo ip link set veth-host-fw up

# IP adreslerini atama
sudo ip addr add 192.0.2.193/26 dev veth-host-fw
sudo ip netns exec firewall ip addr add 192.0.2.194/26 dev veth-fw-host

# Firewall ve Host arayüzlerini aktifleştirme
sudo ip netns exec firewall ip link set veth-fw-host up

# Routing
sudo ip netns exec client1 ip route add default via 192.0.2.2
sudo ip netns exec client2 ip route add default via 192.0.2.66
sudo ip netns exec server ip route add default via 192.0.2.130
sudo ip -n firewall route add default via 192.0.2.193

# IP forwarding ve NAT kuralları
sudo ip netns exec firewall sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
sudo ip netns exec firewall iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
sudo ip netns exec firewall iptables -t nat -A POSTROUTING -o veth-fw-host -j MASQUERADE

echo "Network namespaces and configurations restored."
