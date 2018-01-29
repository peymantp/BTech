#!/bin/bash

#Global
test='nmap -oA results --append-output '
tcpservices="80,443,53,22,0"
udpservices="80,443,53,22,0"
ip_list="192.168.0.12"

for ip in $ip_list ; do
    $test -p $tcpservices $ip
    $test -sU -p $udpservices $ip
    sudo hping3 -c 10 -p 80 -s 1010 -k -S $ip
    exit 0
done