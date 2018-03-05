if [ $# -ne 2 ]
  then
    echo "No arguments supplied"
	exit 1
fi

echo "Setting up IPS"
dnf install at 
dnf install inotify-tools #https://superuser.com/questions/181517/how-to-execute-a-command-whenever-a-file-changes
cp ips.py /usr/local/bin/
cp ips_logger.py /usr/local/bin/
echo "files copied to /usr/local/bin/"
crontab -l | {cat; echo "@reboot /usr/local/bin/ips_logger.py"; echo "@reboot /usr/local/bin/ips.py $1 $2"} | crontab -
#crontab -e opens vim so that's why i do it this way
echo "scripts added to cron"
echo "scripts started"
/usr/local/bin/ips.py
/usr/local/bin/ips_logger.py
echo "Setup complete"