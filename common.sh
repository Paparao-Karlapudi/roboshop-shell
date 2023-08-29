scriptlocation=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
 if [ $? -eq 0 ]
 then
   echo -e "\e[1;32mSUCCESS\e[0m"
 else
   echo -e "\e[1;31mFAILURE\e[0m"
   echo "Refer lof file for more information , LOG -${LOG}"
   exit
 fi
}

print_head(){
  echo -e "\e[35m$1\e[0m"
}

NODEJS(){
  source common.sh

  print_head "Installing Nodejs"
  yum install nodejs -y &>>{LOG}
  status_check


  print_head "Adding ${component}"
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]
  then
    useradd  roboshop
  fi


  print_head "Making directory"
  mkdir -p /app


  print_head "Downloading catalogue"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>{LOG}
  rm -rf /app/*
  status_check


  cd /app

  print_head "Extracting ${component}"
  unzip /tmp/${component}.zip &>>{LOG}
  status_check

  cd /app

  print_head "Installing dependencies"
  npm install &>>{LOG}
  status_check



  print_head "Configuring ${component} service file"
  cp ${scriptlocation}/files/${component}.service /etc/systemd/system/${component}.service &>>{LOG}
  status_check



  print_head "Enabling ${component}"
  systemctl enable ${component} &>>{LOG}
  status_check


  print_head "Starting ${component}"
  systemctl start ${component} &>>{LOG}
  status_check


  print_head "Copying mongod repo file"
  cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{LOG}
  status_check


  print_head Installing mongod client
  yum install mongodb-org-shell -y &>>{LOG}
  status_check


  print_head Loading Schema
  mongo --host mongodb-dev.pappik.online </app/schema/${component}.js &>>{LOG}
  status_check

}