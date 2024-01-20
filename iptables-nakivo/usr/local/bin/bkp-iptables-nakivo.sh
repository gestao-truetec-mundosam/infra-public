#!/bin/bash

# Array de IPs de origem permitidos
ips_origem=("192.168.21.30")
# Limpar todas as regras existentes
iptables -F

# Permitir tráfego de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

interface=$(ip route | awk '/default/ {print $5}')

# Permitir tráfego local para a porta especificada para IPs de origem especificados
for ip in "${ips_origem[@]}"; do
    iptables -A INPUT -p tcp --dport 22 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 2221 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 4443 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 9446 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 9448:10000 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 902 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 3260 -i $inteface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 137:139 -i $interface -s "$ip" -j ACCEPT
    iptables -A INPUT -p tcp --dport 445 -i $interface -s "$ip" -j ACCEPT
done

# Negar todo o tráfego por padrão
iptables -A INPUT -p tcp --dport 22 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 2221 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 4443 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 9446 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 9448:10000 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 902 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 3260 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 137:139 -i $interface -j DROP
iptables -A INPUT -p tcp --dport 445 -i $interface -j DROP

echo "Regras do iptables configuradas com sucesso."
