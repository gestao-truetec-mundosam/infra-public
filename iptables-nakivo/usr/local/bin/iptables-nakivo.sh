#!/bin/bash
# by TrueTec
##########
# Referencia https://helpcenter.nakivo.com/User-Guide/Content/Deployment/System-Requirements/Deployment-Requirements.htm

### VARIAVEIS
# Array de IPs de origem permitidos
ips_origem_mng=("10.1.254.18")  # MGM IPs Acesso porta Web e SSH
range_origem_mng=("10.0.201.1-10.21.201.254")  # MGM Range de Acesso porta Web e SSH
ips_origem=("10.1.254.80" "10.1.254.81" "10.1.254.83")      # IPs Trafego Backup
range_origem=("192.168.227.20-192.168.227.30")      # Range para Trafego Backup

### FUNCOES
show_help() {
    echo "Use: $0 [start|stop|help]"
    echo "  start: Iniciar Regras Iptables"
    echo "  stop: Parar a execucao Regras Iptables "
    echo "  list: Listar as regras "
    echo "  uninstall: Parar remover comente a linah no arquivo /etc/rc.local"
    echo "  help: Exibir mensagens de ajuda"
    echo "  "
    echo "  Adicione os IPs de origem que devem ter acesso nas variaveis, nesse formato:"
    echo "  ips_origem=("192.168.21.30" "10.21.0.80" "172.16.2.2")"
    echo "  range_origem_mng=("10.227.201.1-10.227.201.254")"
    echo "  ips_origem=("10.1.254.80" "10.1.254.81" "10.1.254.83")"
    echo "  range_origem=("192.168.227.20-192.168.227.30")"
}

start(){

    echo "Start Regras Iptables.."

    # Limpar todas as regras existentes
    iptables -F

    # Permitir tráfego de loopback
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

    # obter nome da interface padrao
    interface=$(ip route | awk '/default/ {print $5}')

    # Permitir tráfego para as portas de Gerencia Web e SSH, para os IPs de origem especificados variavel ips_origem_mng
    for ip in "${ips_origem_mng[@]}"; do
        iptables -A INPUT -p tcp --dport 2221 -i $interface -s "$ip" -j ACCEPT
        iptables -A INPUT -p tcp --dport 4443 -i $interface -s "$ip" -j ACCEPT
    done
    for range in "${range_origem_mng[@]}"; do
        iptables -A INPUT -p tcp --dport 2221 -i $interface -m iprange --src-range "$range" -j ACCEPT
        iptables -A INPUT -p tcp --dport 4443 -i $interface -m iprange --src-range "$range" -j ACCEPT
    done

    # Permitir tráfego local para a portas de backup Nakivo, para os IPs de origem especificados variavel ips_origem
    for ip in "${ips_origem[@]}"; do
        iptables -A INPUT -p tcp --dport 9446 -i $interface -s "$ip" -j ACCEPT
        iptables -A INPUT -p tcp -m multiport --dports 9448:10000 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 902 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 3260 -i $inteface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp -m multiport --dports 137:139 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 445 -i $interface -s "$ip" -j ACCEPT
    done
    for range in "${range_origem[@]}"; do
        iptables -A INPUT -p tcp --dport 9446 -i $interface -m iprange --src-range "$range" -j ACCEPT
        iptables -A INPUT -p tcp -m multiport --dports 9448:10000 -i $interface -m iprange --src-range "$range" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 902 -i $interface -m iprange --src-range "$range" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 3260 -i $interface -m iprange --src-range "$range" -j ACCEPT
        #iptables -A INPUT -p tcp -m multiport --dports t137:139 -i $interface -m iprange --src-range "$range" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 445 -i $interface -m iprange --src-range "$range" -j ACCEPT
    done

    # Negar todo o tráfego por padrão
    #iptables -A INPUT -p tcp --dport 2221 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 4443 -i $interface -j DROP
    iptables -A INPUT -p tcp --dport 9446 -i $interface -j DROP
    iptables -A INPUT -p tcp -m multiport --dports 9448:10000 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 902 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 3260 -i $interface -j DROP
    #iptables -A INPUT -p tcp -m multiport --dports 137:139 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 445 -i $interface -j DROP
}

list(){
    echo "Lista Regras Iptables.."
    iptables -L
}

case "$1" in
    start)
        start
        echo ""
        list
        ;;
    stop)
        echo "Stopping regras Iptables..."
        iptables -F
        ;;
    list)
        list
        ;;
    help)
        show_help
        ;;
    uninstall)
        echo "Parar remover comente a linha que executa $0 no arquivo /etc/rc.local"
        ;;
    *)
        echo "Argumento invalido: $1"
        show_help
        ;;
esac
