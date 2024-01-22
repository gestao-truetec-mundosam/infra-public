Iptables Script para Nakivo

Este repositório contém um script Bash para configurar regras do iptables, especificamente projetado para uso com o Nakivo Backup & Replication.
Descrição

O script automatiza o processo de configuração do iptables para o gerenciamento e o tráfego de backup do Nakivo. Ele cria regras para permitir o tráfego em determinadas portas e de endereços IP específicos, melhorando a segurança e o controle do acesso ao sistema.
Recursos

    Criação e configuração automática do arquivo /etc/rc.local.
    Configuração do serviço rc-local.service para sistemas com systemd.
    Instalação e configuração de regras do iptables para gerenciamento e tráfego de backup.

Pré-requisitos

    Um sistema operacional baseado em Linux com iptables instalado.
    Acesso root ou privilégios sudo para executar o script.

Instalação

    Clone o repositório para sua máquina local:

    bash

git clone https://github.com/gestao-truetec-mundosam/infra-public.git

Navegue até o diretório do script:

Torne o script executável:

bash

    chmod +x iptables-nakivo.sh

Uso

Para executar o script, use um dos seguintes comandos:

bash
    
    ./iptables-nakivo.sh install   # Para instalar o script
    ./iptables-nakivo.sh start     # Para iniciar e aplicar as regras do iptables
    ./iptables-nakivo.sh stop      # Para parar e limpar as regras do iptables
    ./iptables-nakivo.sh list      # Para listar as regras atuais do iptables
    ./iptables-nakivo.sh help      # Para exibir a ajuda

Customização

Você pode editar as variáveis ips_origem, range_origem, ips_origem_mng e range_origem_mng no script para especificar os endereços IP e faixas de IPs que devem ser permitidos.
Contribuições

Se você tiver alguma dúvida ou precisar de suporte, entre em contato com TrueTec em infra@truetec.com.br .
