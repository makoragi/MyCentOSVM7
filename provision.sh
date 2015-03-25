
echo "provision.sh"

#==========================================================
## 検討中
# su -
# mkdir /mnt/cdrom
# mount -r /dev/cdrom /mnt/cdrom
# cd /mnt/cdrom
# sh VBoxLinuxAddditions.run install

#==========================================================
## Timezone Settings.
# sudo timedatectl status
sudo timedatectl set-timezone Asia/Tokyo

#==========================================================
## System Settings.
sudo yum groupinstall -y -q Base "GNOME Desktop" "X Window System"

#==========================================================
## Locale Settings.
# sudo localectl status
sudo localectl set-locale LANG=ja_JP.utf8

#==========================================================
## Repositry Settings.
# file_repo="/etc/yum.repos.d/epel.repo"
# if [ ! -f $file_repo ]; then
# 	wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# 	rpm -Uvh epel-release-6-8.noarch.rpm
# 	grep "^enabled" $file_repo | grep "1" > /dev/null
# 	if [ "$?" -eq 0 ] ; then
# 		sudo sed -i 's/^\(enabled\s*=\s*\)\(1\)/#\1\2\n\10/g' $file_repo
# 	fi
# fi
# file_repo="/etc/yum.repos.d/rpmforge.repo"
# if [ ! -f $file_repo ]; then
# 	wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# 	rpm -Uvh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
# 	grep "^enabled" $file_repo | grep "1" > /dev/null
# 	if [ "$?" -eq 0 ] ; then
# 		sudo sed -i 's/^\(enabled\s*=\s*\)\(1\)/#\1\2\n\10/g' $file_repo
# 	fi
# fi
# file_repo="/etc/yum.repos.d/remi.repo"
# if [ ! -f $file_repo ]; then
# 	wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
# 	rpm -Uvh remi-release-6.rpm
# 	grep "^enabled" $file_repo | grep "1" > /dev/null
# 	if [ "$?" -eq 0 ] ; then
# 		sudo sed -i 's/^\(enabled\s*=\s*\)\(1\)/#\1\2\n\10/g' $file_repo
# 	fi
# fi
#==========================================================
## Keyboard Settings.

#==========================================================
## Network Settings.


#==========================================================
## Apache Settings.
if [ ! -x /etc/httpd ]; then
	sudo yum -y install httpd
fi
# sudo systemctl status httpd
sudo systemctl start httpd
sudo systemctl enable httpd
if [ ! -L /var/www/html/sync ]; then
	/bin/ln -s /vagrant/html /var/www/html/sync
fi

#==========================================================
## Shell Settings.
# if [ ! -f /bin/tcsh ]; then
# 	sudo yum install -y tcsh
# fi
# file_passwd="/etc/passwd"
# grep "^vagrant:" $file_passwd | grep "tcsh" > /dev/null
# if [ "$?" -eq 1 ] ; then
# 	sudo sed -i 's/^\(vagrant:.*\):[^:]*/\1:\/bin\/tcsh/g' $file_passwd
# fi
# cp -frp /vagrant/cshrc /home/vagrant/.cshrc

#==========================================================
## MySQL Settings.
if [ ! -x /usr/bin/mysql ]; then
	wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
	sudo rpm -Uvh mysql-community-release-el7-5.noarch.rpm
	file_mysqlconf="/etc/yum.repos.d/mysql-community.repo"
	grep "^enabled=1" $file_mysqlconf > /dev/null
	if [ "$?" -eq 0 ] ; then
		sudo sed -i 's/^enabled=1/enabled=0/g' $file_mysqlconf
	fi
	sudo yum --enablerepo=mysql56-community install -y mysql-community-server
	sudo systemctl start mysqld
fi

#==========================================================
## PHP Settings.
if [ ! -x /usr/bin/php ]; then
	sudo yum install -y php
	file_phpini="/etc/php.ini"
	grep "^date.timezone" $file_phpini > /dev/null
	if [ "$?" -eq 1 ] ; then
		sudo sed -i 's/;*\s*\(date.timezone\s*=\s*\)\(.*\)/;\1\2\n\1 Asia\/Tokyo/g' $file_phpini
	fi
	sudo systemctl restart httpd
fi

echo "end."
