source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing "
  exit
fi

print_head "Disabling mysql module"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Copying mysql repo files"
cp ${scriptlocation}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install mysql server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable Mysql"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start mysql"
systemctl start mysqld &>>${LOG}
status_check

print_head "Reset default database password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
status_check
