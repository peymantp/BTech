#!/bin/sh

#Gloabals 
IPT="/sbin/iptables"

#todo https://learnxinyminutes.com/docs/bash/

# Set default policies for all three default chains
function defaults(){
	$IPT -P INPUT DROP
	$IPT -P FORWARD DROP
	$IPT -P OUTPUT DROP
}

#######################################
# List all rules from all chains unless specified
# Arguments:
#   $1 chain name (optional)
#######################################
function list(){
	if [-z "$1"]; then
		$IPT --list --line-numbers --numeric --verbose
	else
		$IPT --list "$1" --line-numbers --numeric --verbose
	fi
}

# Create new chain name
function new(){
	echo "Input new chain name:"
	read chain
	$IPT --new-chain $chain
	echo "Created $chain chain"
}

function poop(){
	$IPT --flush
	$IPT --delete-chain
}

function add(){
	final = ""

	echo "append or instert rule?[a|i]"
	read add
	if ["$add"=="a"]; then
		final+="--append"
	elif ["$add"=="i"]; then
		final+="--insert"
	else
		echo "invalid input '$add' quiting function"
		return ""
	fi

	echo "enter chain:"
	read chain
	final+=" $chain"

	echo "sourse, destination, or neither? [s|d|n]"
	read direction
		if ["$direction" == "s"]; then
			echo ""
	
	$IPT " $final"
}

while read input;do
	echo $input
done 