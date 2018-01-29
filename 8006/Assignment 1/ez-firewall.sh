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
$IPT -N ACCOUNTANT
$IPT -I INPUT -j ACCOUNTANT
$IPT -I OUTPUT -j ACCOUNTANT

#Drop inbound traffic to port 80 (http) from source ports less than 1024
$IPT --append ACCOUNTANT -p tcp -m tcp --dport 80 --sport 0:1023 --jump DROP
echo 'Drop inbound traffic to port 80 (http) from source ports less than 1024'

#Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0
$IPT -A ACCOUNTANT -p tcp -m tcp --sport 0 -m state --state RELATED,ESTABLISHED -j DROP
$IPT -A ACCOUNTANT -p udp -m udp --sport 0 -m state --state RELATED,ESTABLISHED -j DROP
$IPT -A ACCOUNTANT -p tcp -m tcp --dport 0 -j DROP
$IPT -A ACCOUNTANT -p udp -m udp --dport 0 -j DROP

# allow the machine to browse the internet #Permit inbound/outbound www packets
$IPT -A ACCOUNTANT -p tcp -m tcp --sport 80 -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPT -A ACCOUNTANT -p tcp -m tcp --dport 80 -j ACCEPT
$IPT -A ACCOUNTANT -p tcp -m tcp --sport 443 -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPT -A ACCOUNTANT -p tcp -m tcp --dport 443 -j ACCEPT
echo 'Allow internet browsing'

#Allow DNS and DHCP traffic through so that your machine can function properly
$IPT -A ACCOUNTANT -p udp -m udp --sport 53 -j ACCEPT
$IPT -A ACCOUNTANT -p udp -m udp --dport 53 -j ACCEPT
$IPT -A ACCOUNTANT -p tcp -m tcp --sport 53 -j ACCEPT
$IPT -A ACCOUNTANT -p tcp -m tcp --dport 53 -j ACCEPT
echo 'Allow DNS DHCP'

#Permit inbound/outbound ssh packets
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --source-port 22 --jump ACCEPT
$IPT --append ACCOUNTANT --match state --state NEW --protocol tcp --destination-port 22 --jump ACCEPT
echo 'Allow in/out ssh'
echo 'Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0'

