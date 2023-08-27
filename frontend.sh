scriptlocation=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi
echo -e "\e[35m Remove Nginx Old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi


cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m Extracting frontend content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Roboshop Nginx config file \e[0m"
cp ${scriptlocation}/files/nginx-roboshop.conf /etc/nginx/default.d/robodhop.conf &>>{LOG}
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Start Nginx\e[0m"
systemctl start nginx
if [$? == 0]
then
  echo SUCCESS
else
  echo FAILURE
fi



