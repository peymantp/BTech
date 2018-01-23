#!/bin/bash
user=nix
pass="fbtech"
pass2="""
$pass
$pass
"""
userDirConf="""
<IfModule mod_userdir.c>
    UserDir enabled
    UserDir public_html
</IfModule>
#
# Control access to UserDir directories.  The following is an example
# for a site where these directories are restricted to read-only.
#
<Directory /home/$user>
    AllowOverride None
    #httpd-passwords is a temp name for password file
    AuthUserFile /var/www/html/passwords/passwordfile
    AuthGroupFile /dev/null
    AuthName test
    AuthType Basic
    <Limit GET>
        require valid-user
        order deny,allow
        deny from all
        allow from all
    </Limit>
</Directory>
"""

user(){
	useradd $user
	echo -e "fbtech\nfbtech" | passwd $user
}
apache(){
	user
	dnf install httpd -y

	echo $pass | sudo -S systemctl start httpd.service
	echo $pass | sudo -S systemctl enable httpd.service
	#systemctl status httpd #uncomment when debuging
	(
		cd /etc/httpd/conf.d/
		chmod 777 userdir.conf
		sed -i "s/UserDir disabled/#UserDir disabled/g" userdir.conf
		sed -i "s/#UserDir public_html/UserDir public_html/g" userdir.conf
		sed -i '31,35d;' userdir.conf

		echo "$userDirConf" > userdir.conf;
	)
	(
		cd /home/$user
		mkdir public_html
		cd public_html
		echo " <!DOCTYPE html><html><head><title>Peyman Tehrani Parsa</title></head><body><h1>Heading</h1><p>A00922386</p></body></html>" > index.html
	)
	chmod 777 /home/$user
	chmod 777 /home/$user/public_html
	chmod 777 /home/$user/public_html/index.html
	
	mkdir /var/www/html/passwords
	chmod 777 /var/www/html/passwords
	echo -e "$pass2" | htpasswd -c /var/www/html/passwords/passwordfile $user
	systemctl restart httpd.service
	cd /home
}

NFS(){
	user
	dnf install nfs-utils -y

	cd /home/$user
	echo "AAAAAAAAAAAAAAAAAAAAAAAAAA" > "example_file.txt"
	chmod 777 ./example_file.txt
	#ls -l example_file.txt #uncomment when debuging

	cd /etc
	chmod 777 exports
	#ls -l exports #uncomment when debuging
	{
		echo ""
		echo "/home/$user 192.168.0.0/27(rw,no_root_squash)"
	} >> exports

	systemctl stop nfs
	systemctl start nfs
	/usr/sbin/exportfs -v #-v = verbose
	echo "On client machine type\n$ dnf install nfs-utils\n$ mkdir /mnt/temp\n$ mount -t nfs 192.168.1.xx:/home/$user /mnt/temp"
}

SAMBA(){
	user
	dnf install samba -y
	cd /etc/samba
	chmod 777 smb.conf

	{
		echo ""
		echo "[F323]"
		echo "	comment = Win32 Share"
		echo "	path = /home/nix"
		echo "	public = yes"
		echo "	writable = yes"
		echo "	guest ok = yes"
	} >> smb.conf

	sed -i '11a\	hosts allow = 192.168.0. 127.' smb.conf
	sed -i '8a\	server string = Samba Server' smb.conf
	
	systemctl enable smb.service
	echo -e "sesame\nsesame" | smbpasswd -a open


	systemctl start smb.service

	echo -e "\n\n" | smbclient -L localhost

}

while true
do
	clear
	 cat << 'MENU'	
	A............................ Install and configure Apache
	N............................ Install and configure NFS
 	S............................ Install and configure SAMBA
 	Q............................ Quit
MENU
	echo -n '           Press letter for choice, then Return >'
	read ltr rest
	case ${ltr} in
		[Aa])	apache	;;
		[Ss])	samba	;;
		[Nn])	NFS	;;
		[Qq])	exit	;;
	esac
	echo; echo -n ' Press Enter to continue.....'
	read rest
done
