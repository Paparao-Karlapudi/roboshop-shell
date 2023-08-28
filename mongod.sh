source common.sh

print_head copying mongod repo
cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head Installing mongod
yum install mongodb-org -y &>>${LOG}
status_check

print_head Updating mongodb listening address
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head Enabling mongod
systemctl enable mongod

print_head restarting mongod
systemctl start mongod