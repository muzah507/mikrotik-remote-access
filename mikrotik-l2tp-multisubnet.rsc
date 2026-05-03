# File: configs/mikrotik-l2tp-multisubnet.rsc

# =========================================

# MikroTik L2TP/IPsec VPN + Multi-Subnet

# =========================================

# SANITIZED CONFIG (AMAN UNTUK GITHUB)

# Ganti nilai di bagian VARIABLES sebelum dipakai

# =========================================

# VARIABLES

# =========================================

:local vpnSecret "YOUR_IPSEC_SECRET"
:local vpnUser "YOUR_USERNAME"
:local vpnPass "YOUR_PASSWORD"

# =========================================

# IP ADDRESS (MULTI-SUBNET SETUP)

# =========================================

/ip address
add address=192.168.10.1/24 interface=bridge-wan comment="WAN to ISP Router"
add address=192.168.20.1/24 interface=bridge-server comment="Server Network"
add address=192.168.30.1/24 interface=ether4 comment="Client Network"
add address=192.168.40.1/24 interface=ether5 comment="Additional Network"

# =========================================

# VPN IP POOL

# =========================================

/ip pool
add name=l2tp-pool ranges=192.168.100.10-192.168.100.50

# =========================================

# PPP PROFILE

# =========================================

/ppp profile
add name=l2tp-profile 
local-address=192.168.100.1 
remote-address=l2tp-pool 
dns-server=8.8.8.8

# =========================================

# L2TP SERVER + IPSEC

# =========================================

/interface l2tp-server server
set enabled=yes 
use-ipsec=yes 
ipsec-secret=$vpnSecret 
default-profile=l2tp-profile

# =========================================

# VPN USER

# =========================================

/ppp secret
add name=$vpnUser 
password=$vpnPass 
profile=l2tp-profile 
service=l2tp

# =========================================

# FIREWALL RULES (INPUT)

# =========================================

/ip firewall filter
add chain=input protocol=udp port=500,1701,4500 action=accept comment="Allow L2TP/IPsec"
add chain=input protocol=ipsec-esp action=accept comment="Allow IPsec ESP"
add chain=input protocol=ipsec-ah action=accept comment="Allow IPsec AH"

# =========================================

# FIREWALL RULES (FORWARD VPN ACCESS)

# =========================================

add chain=forward src-address=192.168.100.0/24 action=accept comment="VPN to LAN"
add chain=forward dst-address=192.168.100.0/24 action=accept comment="LAN to VPN"

# =========================================

# ENABLE DDNS

# =========================================

/ip cloud
set ddns-enabled=yes

# =========================================

# NOTES

# =========================================

# - Tidak akan bekerja jika router masih di belakang NAT ISP

# - Gunakan Tailscale atau port forwarding jika perlu remote access

# - Jangan upload credential asli ke GitHub

# =========================================
