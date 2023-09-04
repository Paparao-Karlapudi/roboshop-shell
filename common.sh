scriptlocation=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
 if [ $? -eq 0 ]
 then
   echo -e "\e[1;32mSUCCESS\e[0m"
 else
   echo -e "\e[1;31mFAILURE\e[0m"
   echo "Refer LOG file for more information , LOG -${LOG}"
   exit 1
 fi
}

print_head(){
  echo -e "\e[35m$1\e[0m"
}

APP_PREREQ(){

    print_head "Adding Application user"
    id roboshop &>>${LOG}
    if [ $? -ne 0 ]
    then
      useradd  roboshop
    fi


    print_head "Making directory"
    mkdir -p /app


    print_head "Downloading ${component}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>{LOG}
    rm -rf /app/*
    status_check


    cd /app

    print_head "Extracting ${component}"
    unzip /tmp/${component}.zip &>>{LOG}
    status_check
}

SYSTEMD_SETUP(){
    print_head "Configuring ${component} service file"
    cp ${scriptlocation}/files/${component}.service /etc/systemd/system/${component}.service &>>{LOG}
    status_check

    print_head "Reloading the service"
    systemctl daemon-reload &>>{LOG}
    status_check

    print_head "Enabling ${component}"
    systemctl enable ${component} &>>{LOG}
    status_check


    print_head "Starting ${component}"
    systemctl start ${component} &>>{LOG}
    status_check
  }

LOAD_SCHEMA(){
  if [ ${schema_load} == true ]; then
   if [ ${schema_type} == mongo ]; then
    print_head "Copying mongod repo file"
    cp ${scriptlocation}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>{LOG}
    status_check


    print_head "Installing mongod client"
    yum install mongodb-org-shell -y &>>{LOG}
    status_check


    print_head "Loading Schema"
    mongo --host mongodb-dev.pappik.online </app/schema/${component}.js &>>{LOG}
    status_check
  fi
   if [ ${schema_type} == mysql ]; then

      print_head "Installing mysql client"
      yum install mysql -y &>>{LOG}
      status_check


      print_head "Loading Schema"
      mysql -h mysql-dev.pappik.online -uroot -p${root_mysql_password} </app/schema/shipping.sql &>>{LOG}
      status_check
    fi

fi
}

NODEJS(){

  print_head "Configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{LOG}
  status_check

  print_head "Installing Nodejs"
  yum install nodejs -y &>>{LOG}
  status_check


  APP_PREREQ

  cd /app

  print_head "Installing dependencies"
  npm install &>>{LOG}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA
}

MAVEN(){
  print_head "Intstall Maven"
  yum install maven -y &>>${LOG}
  status_check

  APP_PREREQ

  cd /app

  print_head "build a package"
  mvn clean package &>>${LOG}
  status_check

  print_head "copy app to App Location"
  mv target/${component}-1.0.jar ${component}.jar &>>${LOG}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA
}

PYTHON(){
  print_head "Intstall Python"
  dnf install python36 gcc python3-devel -y &>>${LOG}
  status_check

  APP_PREREQ

  print_head "Download and install dependencies"
  cd /app
  pip3.6 install -r requirements.txt &>>${LOG}
  status_check

  print_head "Update password in service file"
  sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${scriptlocation}/files/${component}.service &>>${LOG}
  status_check

  SYSTEMD_SETUP

}