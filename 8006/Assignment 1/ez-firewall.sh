#!/bin/sh

#Gloabals 
IPT="sudo /sbin/iptables"
# Flushing
$IPT -F
$IPT -X
$IPT -Z

#Set defaults
$IPT --policy INPUT DROP
$IPT --policy FORWARD DROP
$IPT --policy OUTPUT DROP

#Create a set of user-defined chains that will implement accounting rules to keep track of www, ssh traffic, versus the rest of the traffic on your system
$IPT --new MYFILTER
$IPT -I INPUT --jump MYFILTER
$IPT -I OUTPUT --jump MYFILTER

$IPT --new assh
$IPT --new aweb

#Drop inbound traffic to port 80 (http) from source ports less than 1024
$IPT --append MYFILTER --protocol tcp --match tcp --dport 80 --sport 0:1023 --jump DROP
echo 'Drop inbound traffic to port 80 (http) from source ports less than 1024'

#Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0
$IPT --append MYFILTER --protocol tcp --match tcp --sport 0 --match state --state RELATED,ESTABLISHED --jump DROP
$IPT --append MYFILTER --protocol udp --match udp --sport 0 --match state --state RELATED,ESTABLISHED --jump DROP
$IPT --append MYFILTER --protocol tcp --match tcp --dport 0 --jump DROP
$IPT --append MYFILTER --protocol udp --match udp --dport 0 --jump DROP
echo 'Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0'

# allow the machine to browse the internet #Permit inbound/outbound www packets
$IPT --append MYFILTER --protocol tcp --match tcp --sport 80 --match state --state RELATED,ESTABLISHED --jump aweb
$IPT --append MYFILTER --protocol tcp --match tcp --dport 80 --jump aweb
$IPT --append MYFILTER --protocol tcp --match tcp --sport 443 --match state --state RELATED,ESTABLISHED --jump aweb
$IPT --append MYFILTER --protocol tcp --match tcp --dport 443 --jump aweb
$IPT --append aweb --jump ACCEPT

echo 'Allow internet browsing'

#Allow DNS and DHCP traffic through so that your machine can function properly
$IPT --append MYFILTER --protocol udp --match udp --sport 53 --jump ACCEPT
$IPT --append MYFILTER --protocol udp --match udp --dport 53 --jump ACCEPT
$IPT --append MYFILTER --protocol tcp --match tcp --sport 53 --jump ACCEPT
$IPT --append MYFILTER --protocol tcp --match tcp --dport 53 --jump ACCEPT
echo 'Allow DNS DHCP'

#Permit inbound/outbound ssh packets
$IPT --append MYFILTER --match state --state NEW --protocol tcp --source-port 22 --jump assh
$IPT --append MYFILTER --match state --state NEW --protocol tcp --destination-port 22 --jump assh
$IPT --append assh --jump ACCEPT
echo 'Allow in/out ssh'

