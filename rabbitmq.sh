source common.sh

if [ -z "${roboshop_rabbitmq_password}" ];then
  echo "varibale roboshop_rabbitmq_password is empty"
  exit
fi

print_head "Configuring Repos rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Configuring YUM Repos rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG}
status_check

print_head "Unstall Rabbitmq server"
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable rabbitmq"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start rabbitmq"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Adding rabbitmq user"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
status_check

print_head "Setting rabbitmq permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check