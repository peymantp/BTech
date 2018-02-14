# Requirements
## Objective
To design, implement and test a standalone Linux firewall and packet filter

## Constraints
1 - use netfilter
2 - load user configuration for all forwarded traffic
3 - set default policies for firewall
4 - dns, dhcp enabled
5 - in/out tcp/udp ports, icmp types
6 - default rule = drop
7 - reject wrong way (i.e. syn in on high ports)
8 - accept fragments
9 - drop tcp with SYN & FIN set
10 - no telnet packets allowed
11 - block external 111, 137-139, 515, 32768-32775
12 - ftp/ssh minimum delay,
13 - ftp max thruput
14 - first [en01] = outside, second [enp3s2] = inside
15 - test procedure; test rules, print results (log)
16 - need to know which rule passed/failed

## evaluation
10% - Design
10% - Docs/Help
50% - Functionality
30% - Testing

## firewall tests

## user rules
define filename
load <filename>
define networks; internal/external x device/network/mask
define allowed tcp/udp/icmp
stateful filtering
inbound vs outbound behaviour

# Design
## script1 - configuration

## script2 - Testing

## user configuration
get config <filename>
use config file -
    while read LINE; do;
        # process LINE
    done
internal device/network/mask
external device/network/mask
TCP allowed
UDP allowed
ICMP allowed
