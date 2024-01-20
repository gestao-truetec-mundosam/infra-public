#!/bin/bash
# by TrueTec

### VARIAVEIS
# Array de IPs de origem permitidos
ips_origem=("192.168.21.30" "10.21.0.80" "172.16.2.2")

### FUNCOES
show_help() {
    echo "Use: $0 [start|stop|help]"
    echo "  start: Iniciar Regras Iptables"
    echo "  stop: Parar a execucao Regras Iptables "
    echo "  list: Listar as regras "
    echo "  uninstall: Parar remover comente a linah no arquivo /etc/rc.local"
    echo "  help: Exibir mensagens de ajuda"
    echo "  "
    echo "  Adicione os IPs de origem que devem ter acesso na variavel, nesse formato:"
    echo "  ips_origem=("192.168.21.30" "10.21.0.80" "172.16.2.2")"
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

    # Permitir tráfego local para a porta especificada para IPs de origem especificados
    for ip in "${ips_origem[@]}"; do
        iptables -A INPUT -p tcp --dport 22 -i $interface -s "$ip" -j ACCEPT
        iptables -A INPUT -p tcp --dport 2221 -i $interface -s "$ip" -j ACCEPT
        iptables -A INPUT -p tcp --dport 4443 -i $interface -s "$ip" -j ACCEPT
        iptables -A INPUT -p tcp --dport 9446 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 9448:10000 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 902 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 3260 -i $inteface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 137:139 -i $interface -s "$ip" -j ACCEPT
        #iptables -A INPUT -p tcp --dport 445 -i $interface -s "$ip" -j ACCEPT
    done

    # Negar todo o tráfego por padrão
    #iptables -A INPUT -p tcp --dport 22 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 2221 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 4443 -i $interface -j DROP
    iptables -A INPUT -p tcp --dport 9446 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 9448:10000 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 902 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 3260 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 137:139 -i $interface -j DROP
    #iptables -A INPUT -p tcp --dport 445 -i $interface -j DROP
}

list(){
    echo "Lista Regras Iptables.."
    iptables -L
}

case "$1" in
    start)
        #start
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
