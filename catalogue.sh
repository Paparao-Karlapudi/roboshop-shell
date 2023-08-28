source common.sh

print_head Installing Nodejs
yum install nodejs -y &>>{LOG}
status_check


print_head Adding User
id roboshop
if [ $? -ne 0];then
useradd  roboshop
fi
#check
print_head Making directory
mkdir -p /app


print_head Downloading catalogue
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{LOG}
rm -rf /app/*
status_check


cd /app

print_head Extracting catalogue
unzip /tmp/catalogue.zip &>>{LOG}
status_check

cd /app

print_head Installing dependencies
npm install &>>{LOG}
status_check



print_head Configuring catalogue service file
cp ${scriptlocation}/files/catalogue.service /etc/systemd/system/catalogue.service &>>{LOG}
status_check



print_head Enabling Catalogue
systemctl enable catalogue &>>{LOG}
status_check


print_head Starting Catalogue
systemctl start catalogue &>>{LOG}
status_check


print_head Copying mongod repo file
cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{LOG}
status_check


print_head Installing mongod client
yum install mongodb-org-shell -y &>>{LOG}
status_check


print_head Loading Schema
mongo --host mongodb-dev.pappik.online </app/schema/catalogue.js &>>{LOG}
status_check
