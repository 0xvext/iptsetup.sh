# iptsetup.sh
A quick and dirty setup script for iptables

Usage: ./iptsetup.sh

# ./iptsetup.sh 
###############################################################
Adding accept loopback incoming/outgoing rules...
Adding accept established/related incoming rule...
Adding accept established outgoing rule...
Adding drop invalid incoming rule...
###############################################################
Enter a source IP/range (Single IP or CIDR): 192.0.2.1
###############################################################
Do you wish to enable SSH from 192.0.2.1?
1) Yes
2) No
#? 1
###############################################################
Adding accept SSH incoming rule...
Adding accept SSH established outgoing rule...
###############################################################
Do you wish to enable HTTP/S from 192.0.2.1?
1) Yes
2) No
#? 1
###############################################################
Adding accept HTTP/S incoming rule...
Adding accept HTTP/S established outgoing rule...
###############################################################
Do you wish to block all other connections?
1) Yes
2) No
#? 1
###############################################################
Adding drop incoming rule...
######################################################################################################################################################
Printing rules for review...
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           
2        0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
3        0     0 DROP       all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate INVALID
4        0     0 ACCEPT     tcp  --  *      *       192.0.2.1            0.0.0.0/0            tcp dpt:22 ctstate NEW,ESTABLISHED
5        0     0 ACCEPT     tcp  --  *      *       192.0.2.1            0.0.0.0/0            multiport dports 80,443 ctstate NEW,ESTABLISHED
6        0     0 DROP       all  --  eth0   *       0.0.0.0/0            0.0.0.0/0           

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1        0     0 ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0           
2        0     0 ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ctstate ESTABLISHED
3        0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp spt:22 ctstate ESTABLISHED
4        0     0 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            multiport dports 80,443 ctstate ESTABLISHED
######################################################################################################################################################
Do you wish to save changes to persistent rules?
1) Yes
2) No
#? 1
###########################################################################################
Saving rules...
run-parts: executing /usr/share/netfilter-persistent/plugins.d/15-ip4tables save
run-parts: /usr/share/netfilter-persistent/plugins.d/15-ip4tables exited with return code 1
run-parts: executing /usr/share/netfilter-persistent/plugins.d/25-ip6tables save
run-parts: /usr/share/netfilter-persistent/plugins.d/25-ip6tables exited with return code 1
###########################################################################################
Finished!
