#!/bin/bash

LOGS_FOLDER="/var/log/expense" #log file
SCRIPT_NAME=$(echo $0 |cut -d "." -f11) #$0 command run inside shell script # cut -d "." -f1 (dilimater)
TIMESTAMP=$(date +%Y-%m-%S-%H-%M-%S) #time stamp
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m" #reset color 
        
        USERID=$(id -u)   # Check if the user is root
        
        CHECK_ROOT(){ 
            #to check the user is having root access are not  #    echo "user ID is:$USERID"
        
         if [ $USERID -ne 0 ]
    then 
        echo -e "$R please run the script with root user $N" | tee -a $LOG_FILE
    else
        exit 1

    fi
}
        VALIDATE(){
        if [ $1 -ne 0 ]
    then 
        echo -e "$2 is...$R FAILED $N" | tee -a $LOG_FILE
        exit 1 
     else
        echo -e "$2 is...$G SUCCESS $N" | tee -a $LOG_FILE
    fi
} 

    echo "script started executing at: $(date)" |tee -a $LOG_FILE
    # Run the root check function
    CHECK_ROOT
    dnf install mysql-server -y &>>$LOG_FILE
    VALIDATE $? "installing Mysql server"

    systemctl enable mysqld &>>$LOG_FILE
    VALIDATE $? "enable mysql server"

    systemctl start mysqld &>>$LOG_FILE
    VALIDATE $? "started mysql server"

    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
    VALIDATE $? "setting root password"
    






