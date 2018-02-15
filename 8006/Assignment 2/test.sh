#Usage ./test <IP of target> &> test
red=$'\e[1;31m'
grn=$'\e[1;32m'
end=$'\e[0m'
source config.sh >/dev/null
test="hping3 $1 -V"

rm ./test_result


echo 'TCP allowed ports'
for i in $tcp_; do
	$test -S -p $i -c 1 >> test_result
	if [  $? -eq 0 ]; then
	    echo "$ip:$i is open and ${grn}PASSED${end}"
	else
	    echo "$ip:$i is closed and ${red}FAILED${end}"
	fi
done

echo 'UDP allowed ports'
for i in $udp_; do
	$test --udp -S -p $i -c 1 >> test_result
	if [  $? -eq 0 ]; then
	    echo "$ip:$i is open and ${grn}PASSED${end}"
	else
	    echo "$ip:$i is closed and ${red}FAILED${end}"
	fi
done

echo 'ICMP allowed ports'
for i in $icmp_; do
	$test -S -p $i -2 -c 1 >> test_result
	if [  $? -eq 0 ]; then
	    echo "$ip:$i is open and ${grn}PASSED${end}"
	else
	    echo "$ip:$i is closed and ${red}FAILED${end}"
	fi
done

echo 'TCP deny ports'
for i in $tcp_deny; do
	$test -S -p $i -c 1 >> test_result
	if [  $? -eq 0 ]; then
	    echo "$ip:$i is open and ${red}FAILED${end}"
	else
	    echo "$ip:$i is closed and ${grn}PASSED${end}"
	fi
done

echo 'UDP deny ports'
for i in $udp_deny; do
	$test --udp -S -p $i -c 1 >> test_result
	if [  $? -eq 0 ]; then
		echo "$ip:$i is open udp ${red}FAILED${end}"
else
		echo "$ip:$i is closed and ${grn}PASSED${end}"
	fi
done

echo 'ICMP deny ports'
for i in $icmp_; do
	$test -S -p $i -1 -c 1 >> test_result
	if [  $? -eq 0 ]; then
		echo "$ip:$i is open and ${red}FAILED${end}"
else
		echo "$ip:$i is closed and ${grn}PASSED${end}"
	fi
done

echo 'SYN FIN test'
$test -c 1 -s 1000 -p 80 -SF 
if [  $? -eq 0 ]; then
		echo "$ip:$i is open and allowed the SYN FIN packet ${red}FAILED${end}"
else
		echo "$ip:$i is closed and blocked the SYN FIN packet ${grn}PASSED${end}"
fi

echo 'Spoof subnet'
$test -c 1 -S -s 80 -p 80 --spoof 192.168.10.5

test -S -p 22 -c 1 -f >> test_result
if [  $? -eq 0 ]; then
	echo "$ip:22 is open and ${grn}PASSED${end} the test"
else
	echo "$ip:22 is closed and ${red}FAILED${end} the test"
fi
