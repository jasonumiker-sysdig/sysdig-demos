#!/bin/bash
apt update
apt upgrade -y
ufw firewall disable
iptables -F
