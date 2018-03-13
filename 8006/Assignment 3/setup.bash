if [ $# -ne 2 ]
  then
    echo "No arguments supplied"
	exit 1
fi

echo "Setting up IPS"
dnf intall inotify-tools -y
atq

cp runner.sh /usr/local/etc/
cp ips.awk /usr/local/etc/
chmod +x /usr/local/etc/*

cp ips.service /etc/systemd/system/
chmod +x /etc/systemd/system/ips.service
systemctl daemon-reload
systemctl enable ips.service
echo "service started"

echo "Setup complete"