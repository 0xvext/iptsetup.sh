#!/bin/bash

# IP Tables quick-setup script
# Relies on iptables and iptables-persistent being installed

# Configure default allow rules
# Allow loopback connections
echo '###############################################################'
echo 'Adding accept loopback incoming/outgoing rules...'
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
# Allow established and related incoming traffic
echo 'Adding accept established/related incoming rule...'
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Allow established outgoing traffic
echo 'Adding accept established outgoing rule...'
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
# Drop invalid input traffic
echo 'Adding drop invalid incoming rule...'
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
echo '###############################################################'

# Prompt for source IP/range (Single IP or CIDR)
read -p 'Enter a source IP/range (Single IP or CIDR): ' SOURCEIP
echo '###############################################################'

# Prompt for configuring SSH
echo "Do you wish to enable SSH from $SOURCEIP?"
select yn in "Yes" "No"; do
    case $yn in
        # Allow SSH from a single IP/range
        Yes ) echo '###############################################################';echo 'Adding accept SSH incoming rule...';iptables -A INPUT -p tcp -s $SOURCEIP --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT;echo 'Adding accept SSH established outgoing rule...';iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT;echo '###############################################################';break;;
        No ) break;;
    esac
done

# Prompt for configuring HTTP/S
echo "Do you wish to enable HTTP/S from $SOURCEIP?"
select yn in "Yes" "No"; do
    case $yn in
    # Allow HTTP/S from a single IP/range
        Yes ) echo '###############################################################';echo 'Adding accept HTTP/S incoming rule...';iptables -A INPUT -p tcp -s $SOURCEIP -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT;echo 'Adding accept HTTP/S established outgoing rule...';iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT;echo '###############################################################';break;;
        No ) break;;
    esac
done

# Prompt for configuring custom port(s) (future)

# Prompt for blocking all other connections
echo "Do you wish to block all other connections?"
select yn in "Yes" "No"; do
    case $yn in
    # Block all undefined connections to interface
        Yes ) echo '###############################################################';echo 'Adding drop incoming rule...';iptables -A INPUT -i eth0 -j DROP;echo '######################################################################################################################################################';break;;
        No ) break;;
    esac
done

# Print current rule set for review
echo 'Printing rules for review...'
iptables -n -L -v --line-numbers
echo '######################################################################################################################################################'

# Prompt for saving rules as persistent
echo "Do you wish to save changes to persistent rules?"
select yn in "Yes" "No"; do
    case $yn in
    # Save rules as currently set
        Yes ) echo '###########################################################################################';echo 'Saving rules...';netfilter-persistent save;break;;
        No ) break;;
    esac
done

echo '###########################################################################################'
echo 'Finished!'
