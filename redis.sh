source common.sh

print_head "Installing Redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>{LOG}
status_check

print_head "Enabling 6.2 dnf module"
yum module enable redis:remi-6.2 -y &>>{LOG}
status_check


print_head "Installing Redis"
yum install redis -y &>>{LOG}
status_check

print_head "Configuring redis"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>{LOG}
status_check

print_head "Enabling redis"
systemctl enable redis &>>{LOG}

print_head "restarting redis"
systemctl start redis &>>{LOG}