source common.sh

component=payment
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ];then
  echo "varibale roboshop_rabbitmq_password is empty"
  exit
fi

PYTHON