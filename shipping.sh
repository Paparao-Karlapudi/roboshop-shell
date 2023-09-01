source common.sh
if [ -z "${root_mysql_password}" ];then
  echo "varibale root_mysql_password is empty"
  exit
fi

component=shipping

schema_load=true
schema_type=mysql

MAVEN

