scriptlocation=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
 if [ $? -eq 0 ]
 then
   echo SUCCESS
 else
   echo FAILURE
 fi
}