source common.sh

echo -e "\e[35m Installing Nodejs \e[0m"
yum install nodejs -y &>>{LOG}
status_check


echo -e "\e[35m Adding User \e[0m"
useradd  roboshop

echo -e "\e[35m Making directory \e[0m"
mkdir -p /app


echo -e "\e[35m Downloading catalogue \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>{LOG}
rm -rf /app/*
status_check


cd /app

echo -e "\e[35m Extracting catalogue \e[0m"
unzip /tmp/catalogue.zip &>>{LOG}
status_check

cd /app

echo -e "\e[35m Installing dependencies \e[0m"
npm install &>>{LOG}
status_check



echo -e "\e[35m Configuring catalogue service file \e[0m"
cp ${scriptlocation}/files/catalogue.service /etc/systemd/system/catalogue.service &>>{LOG}
status_check



echo -e "\e[35m Enabling Catalogue \e[0m"
systemctl enable catalogue &>>{LOG}
status_check


echo -e "\e[35m Starting Catalogue \e[0m"
systemctl start catalogue &>>{LOG}
status_check


echo -e "\e[35m Copying mongod repo file \e[0m"
cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{LOG}
status_check


echo -e "\e[35m Installing mongod client \e[0m"
yum install mongodb-org-shell -y &>>{LOG}
status_check


echo -e "\e[35m Loading Schema \e[0m"
mongo --host mongodb-dev.pappik.online </app/schema/catalogue.js &>>{LOG}
status_check
