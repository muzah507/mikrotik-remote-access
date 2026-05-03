# Secure Remote Access to MikroTik (L2TP/IPsec VPN)

## 📖 Overview

This repository documents a secure method for remotely accessing a MikroTik router using **L2TP/IPsec VPN** on RouterOS v6.

The solution is designed to:

* Enable remote administration from anywhere
* Avoid exposing management ports (e.g., Winbox) to the public internet
* Maintain a balance between security and simplicity without additional hardware

---

## 🎯 Objectives

* Establish encrypted remote connectivity to MikroTik
* Prevent unauthorized external access
* Provide a reproducible and lightweight configuration for RouterOS v6 environments

---

## 🏗️ Network Architecture

```id="arch001"
          Internet
              │
              ▼
     VPN Client (Laptop / Mobile)
              │
      L2TP/IPsec Tunnel
              │
              ▼
        MikroTik Router
              │
              ▼
        Local Network
       (192.168.x.x)
```

---

## ⚙️ Environment

| Component    | Details           |
| ------------ | ----------------- |
| Device       | MikroTik hEX      |
| RouterOS     | v6.49.15 (Stable) |
| Architecture | MMIPS             |
| VPN Protocol | L2TP/IPsec        |

---

## 🔐 Security Considerations

This implementation follows these security principles:

* No direct exposure of management ports (Winbox/WebFig)
* Encrypted communication using IPsec
* Credential abstraction (no hardcoded secrets in documentation)

### ⚠️ Sensitive Data Policy

Do **NOT** include the following in this repository:

* Real public IP addresses
* Usernames and passwords
* IPsec pre-shared keys
* Router backup files (.backup)

Use placeholders instead:

```id="sec001"
YOUR_PUBLIC_IP
YOUR_USERNAME
YOUR_PASSWORD
YOUR_IPSEC_SECRET
```

---

## 🚀 Configuration Steps (MikroTik)

### 1. Enable L2TP Server with IPsec

```id="cfg001"
/interface l2tp-server server set enabled=yes use-ipsec=yes ipsec-secret=YOUR_IPSEC_SECRET default-profile=default
```

---

### 2. Create IP Pool

```id="cfg002"
/ip pool add name=l2tp-pool ranges=192.168.100.10-192.168.100.50
```

---

### 3. Configure PPP Profile

```id="cfg003"
/ppp profile add name=l2tp-profile local-address=192.168.100.1 remote-address=l2tp-pool dns-server=8.8.8.8
```

---

### 4. Create VPN User

```id="cfg004"
/ppp secret add name=YOUR_USERNAME password=YOUR_PASSWORD profile=l2tp-profile service=l2tp
```

---

### 5. Firewall Rules (Allow VPN Traffic)

```id="cfg005"
/ip firewall filter add chain=input protocol=udp port=500,1701,4500 action=accept comment="Allow L2TP/IPsec"
/ip firewall filter add chain=input protocol=ipsec-esp action=accept comment="Allow IPsec ESP"
/ip firewall filter add chain=input protocol=ipsec-ah action=accept comment="Allow IPsec AH"
```

---

## 📱 Client Configuration

### Mobile (Android / iOS)

* VPN Type: L2TP/IPsec PSK
* Server: YOUR_PUBLIC_IP
* Username: YOUR_USERNAME
* Password: YOUR_PASSWORD
* IPsec Secret: YOUR_IPSEC_SECRET

---

### Desktop (Linux / Windows)

Use native VPN client with identical parameters.

---

## 🔎 Post-Connection Access

Once connected:

* Winbox → `192.168.1.1`
* WebFig → `http://192.168.1.1`

---

## 🛠️ Troubleshooting Guide

### Connection Fails

* Ensure UDP ports **500, 1701, 4500** are open
* Verify public IP (not CGNAT/private ISP IP)

### Connected but No LAN Access

* Check IP pool and PPP profile configuration
* Verify routing table

### Intermittent Disconnect

* Inspect ISP stability
* Use reliable DNS (e.g., 8.8.8.8 / 1.1.1.1)

---

## 📌 Limitations

* RouterOS v6 does not support modern mesh VPN solutions like Tailscale
* L2TP/IPsec may be blocked on restrictive networks
* Performance depends on device capability (MMIPS architecture)

---

## 🔄 Future Improvements

* Migration to RouterOS v7 (if hardware permits)
* Integration with Zero Trust VPN (e.g., Tailscale)
* Enhanced firewall hardening (IP whitelisting, brute-force protection)

---

## 👤 Author

**Muhammad Hamzah M.**

---

## 📄 License

This project is open for educational and personal development use.
