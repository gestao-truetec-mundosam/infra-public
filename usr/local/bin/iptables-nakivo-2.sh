#!/bin/bash
# by TrueTec

show_help() {
    echo "Use: $0 [start|stop|help]"
    echo "  start: Iniciar Regras Iptables"
    echo "  stop: Parar a execucao Regras Iptables "
    echo "  uninstall: Parar remover comente a linah no arquivo /etc/rc.local"
    echo "  help: Exibir mensagens de ajuda"
    echo "  "
    echo "  Adicione os IPs de origem que devem ter acesso na variavel"
    echo "  "
}

case "$1" in
    start)
        echo "Starting the service..."
        # Add your code to start the service here
        ;;
    stop)
        echo "Stopping the service..."
        # Add your code to stop the service here
        ;;
    help)
        show_help
        ;;
    uninstall)
	echo "Parar remover comente a linah no arquivo /etc/rc.local"
	;;
    *)
        echo "Argumento invalido: $1"
        show_help
        ;;
esac
