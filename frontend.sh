source common.sh
#
print_head "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "Remove Nginx Old content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check


cd /usr/share/nginx/html &>>${LOG}

print_head "Extracting frontend content"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Roboshop Nginx config file"
cp ${scriptlocation}/files/nginx-roboshop.conf /etc/nginx/default.d/robodhop.conf &>>{LOG}
status_check

print_head "Enable Nginx"
systemctl enable nginx
status_check

print_head "Start Nginx"
systemctl start nginx
status_check



