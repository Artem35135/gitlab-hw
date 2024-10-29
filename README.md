# Домашнее задание к занятию "Система мониторинга Zabbix" - "Засим Артем"


---

### Задание 1

https://github.com/Artem35135/gitlab-hw/blob/main/img/zabbix.png

sudo -s

wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest+ubuntu22.04_all.deb
apt update

apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-apache-conf zabbix-sql-scripts

su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\'123456789\'';"'
su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"'

zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

sed -i 's/# DBPassword=/DBPassword=123456789/g' /etc/zabbix/zabbix_server.conf

systemctl restart zabbix-server apache2
systemctl enable zabbix-server apache2
systemctl status zabbix-server


---

### Задание 2

https://github.com/Artem35135/gitlab-hw/blob/main/img/zabbix1.png
https://github.com/Artem35135/gitlab-hw/blob/main/img/zabbix2.png
https://github.com/Artem35135/gitlab-hw/blob/main/img/zabbix3.png

sudo -s
wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bdebian11_all.deb
dpkg -i zabbix-release_6.0-4+debian11_all.deb
apt update
sudo apt install zabbix-agent -y
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
sed -i 's/Server=127.0.0.1/Server=10.5.0.10/g' /etc/zabbix/zabbix_agentd.conf
sudo systemctl restart zabbix-agent
sudo systemctl status zabbix-agent

---


