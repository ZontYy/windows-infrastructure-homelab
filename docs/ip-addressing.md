# Windows Server

- Hostname: DC01
- NIC: VMnet8
  - Network type: NAT
- IP address (static): 192.168.40.250/24
- Subnet mask: 255.255.255.0
- Gateway: 192.168.40.2

# Windows Client

- Hostname: CLIENT01
- NIC: VMnet8
  - Network type: NAT
- IP address: DHCP
- DNS: Windows Server => 192.168.40.250
- Gateway: 192.168.40.2
