
##voici comment lancer le script
sudo bash Protect.sh
### ici sudo bash script.sh

#!/bin/bash

# Installation de iptables-persistent
apt-get install -y iptables-persistent

# Création d'une chaîne pour les logs DDoS
iptables -N DDoS-LOG

# Ajout des règles pour journaliser les connexions TCP et UDP
iptables -A DDoS-LOG -p tcp --syn -m limit --limit 20/s --limit-burst 40 -j LOG --log-prefix "DDoS TCP Flood: "
iptables -A DDoS-LOG -p udp -m limit --limit 20/s --limit-burst 40 -j LOG --log-prefix "DDoS UDP Flood: "

# Envoi d'un message Discord lorsqu'une attaque DDoS est détectée
iptables -A DDoS-LOG -j DROP && curl -H "Content-Type: application/json" -X POST -d '{"content": "DDoS detected on your FiveM server!"}' <YOUR_DISCORD_WEBHOOK_URL>

# Enregistrement des règles Iptables
iptables-save > /etc/iptables/rules.v4

# Redémarrage du service Iptables
systemctl restart netfilter-persistent
