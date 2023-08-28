scriptlocation=$(pwd)
LOG=/tmp/roboshop.log
status_check() {
 if [ $? -eq 0 ]
 then
   echo -e "\e[1;32mSUCCESS\e[om"
 else
   echo -e "\e[1;31mFAILURE\e[0m"
   echo "Refer lof file for more information , LOG-$(LOG)"
   exit
 fi
}

print_head(){
  echo -e "\e[35m$1\e[0m"
}