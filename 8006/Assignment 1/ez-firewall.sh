#!/bin/sh

#Gloabals 
IPT="/sbin/iptables"

#Set defaults
$IPT --policy INPUT DROP
$IPT --policy FORWARD DROP
$IPT --policy OUTPUT DROP

#Create a set of user-defined chains that will implement accounting rules to keep track of www, ssh traffic, versus the rest of the traffic on your system
$IPT -N ACCOUNTANT
$IPT -I INPUT --jump ACCOUNTANT
$IPT -I FORWARD --jump ACCOUNTANT
$IPT -I OUTPUT --jump ACCOUNTANT

#Drop all SYN packets unless in state nothing to do with port
$IPT -A ACCOUNTANT --protocol tcp --tcp-flags SYN,ACK,FIN,RST SYN --jump DROP

#Allow DNS and DHCP traffic through so that your machine can function properly
$IPT --append ACCOUNTANT --protocol udp --match udp --destination-port 67 --jump ACCEPT
$IPT --append ACCOUNTANT --protocol udp --match udp --destination-port 53 --jump ACCEPT
$IPT -I ACCOUNTANT 1 -m state --state RELATED,ESTABLISHED --jump ACCEPT
$IPT -A ACCOUNTANT -p udp --dport 53 -m state --state NEW --jump ACCEPT

#Permit inbound/outbound ssh packets
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --source-port 22 --jump ACCEPT
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --destination-port 22 --jump ACCEPT

#Permit inbound/outbound www packets
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --source-port 443 --jump ACCEPT
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --destination-port 443 --jump ACCEPT

#Drop inbound traffic to port 80 (http) from source ports less than 1024
$IPT --append ACCOUNTANT --destination-port 80 --source-port 0:1023 DROP

#Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0
$IPT --append ACCOUNTANT --source-port 0
$IPT --append ACCOUNTANT --destination-port 0