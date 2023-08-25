scriptlocation=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m copying mongod repo\e[0m"
cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}

echo -e "\e[35m Installing mongod\e[0m"
yum install mongodb-org -y &>>${LOG}

cho -e "\e[35m Changing localhost to open\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[35m Enaling mongod\e[0m"
systemctl enable mongod

echo -e "\e[35m restarting mongod\e[0m"
systemctl start mongod