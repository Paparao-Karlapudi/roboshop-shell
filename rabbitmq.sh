source common.sh

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