#!/bin/bash

# IP Tables quick-ad script
# Relies on iptables and iptables-persistent

echo '###############################################################'

# Prompt for source IP/range (Single IP or CIDR)
read -p 'Enter a source IP/range (Single IP or CIDR): ' SOURCEIP
echo '###############################################################'

MOREPORTS='y'

while [ $MOREPORTS = 'y' ]
do
	MOREPORTS='n'

	# Prompt for configuring custom port(s) (future)
	read -p 'Enter a custom single TCP port to allow: ' CUSTOMPORT

	echo "Do you wish to enable from $SOURCEIP to TCP $CUSTOMPORT?"
	select yn in "Yes" "No"; do
	    case $yn in
	        # Allow $CUSTOMPORT from a single IP/range
	        Yes ) echo '###############################################################';echo 'Adding accept TCP '$CUSTOMPORT' incoming rule...';iptables -I INPUT 3 -p tcp -s $SOURCEIP --dport $CUSTOMPORT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT;echo 'Adding accept TCP '$CUSTOMPORT' established outgoing rule...';iptables -I OUTPUT 2 -p tcp --sport $CUSTOMPORT -m conntrack --ctstate ESTABLISHED -j ACCEPT;echo '###############################################################';break;;
	        No ) break;;
	    esac
	done
	read -p 'Do you wish to configure another custom port? y/n: ' MOREPORTS
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
