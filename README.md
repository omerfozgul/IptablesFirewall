
# Iptables Firewall Setup

This guide provides instructions on how to set up a network environment using iptables and network namespaces to simulate a firewall system.

## Setup

The setup involves creating four network namespaces (client1, client2, server, firewall), configuring virtual ethernet (veth) pairs for communication, and setting up routing and firewall rules.


### Running the Setup Script

Execute the `setup.sh` script to create namespaces, veth pairs, and apply initial IP configurations and routes.

```bash
./setup.sh
```

## Testing

To verify the correct configuration and functionality of the firewall rules, use the `test.sh` script. This script tests various scenarios like connectivity and restrictions set by the firewall.

### Running the Test Script

Run the `test.sh` script to execute the tests.

```bash
./test.sh
```

### Expected Outputs

1. Client1 should successfully ping the server.
2. Client2 should be able to make an HTTP request to the server.
3. Client2 should be able to ping the firewall.
4. Client1 should not be able to ping the firewall.
5. Attempts to access the internet from client1, client2, and the server should fail (simulate no external access).

