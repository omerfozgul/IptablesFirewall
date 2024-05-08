echo "----- CLIENT1 PING TO SERVER -----"
sudo ip netns exec client1 ping -c 2 192.0.2.129

echo ""

echo "----- CLIENT1 ACCESS TO SERVER FOR HTTP -----"
sudo ip netns exec client2 curl 192.0.2.129

echo ""

echo "----- CLIENT2 PING TO FIREWALL -----"
sudo ip netns exec client2 ping -c 2 192.0.2.66

echo ""

echo "----- CLIENT1 PING TO FIREWALL (NOT ALLOWED)-----"
sudo ip netns exec client1 ping -c 2 192.0.2.194

echo ""

echo "----- CLIENT1, CLIENT2 and SERVER PING TO 8.8.8.8 -----"
sudo ip netns exec client1 ping -c 2 8.8.8.8
echo ""
sudo ip netns exec client2 ping -c 2 8.8.8.8
echo ""
sudo ip netns exec server ping -c 2 8.8.8.8