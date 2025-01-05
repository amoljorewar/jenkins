#!/bin/bash

public_ip=`nslookup myip.opendns.com resolver1.opendns.com | grep -i Address | sed -n '2 p' | cut -d " " -f2`
tomcat_process=`ps -ef | grep -i tomcat | wc -l`
java_package=`rpm -qa | grep -i java | wc -l`
jenkins_initial_pwd=`cat /root/.jenkins/secrets/initialAdminPassword`

echo "==============================================="
echo "**********Initializing Jenkins setup***********"
echo "==============================================="
if [ $java_package == 0 ]
then
   echo "===================================="
   echo "**********Installing Java***********"
   echo "===================================="
   yum install java -y >/dev/null
   echo "========================================"
   echo "****java package has been installed*****"
   echo "========================================"
else
   echo "========================================"
   echo "***java package is already installed****"
   echo "========================================"
fi

if [ -f ~/apache-tomcat-10.1.33 ]
then
   echo "========================================"
   echo "*****Apache tomcat already exists*******"
   echo "========================================"   
else
   echo "==============================================="
   echo "**********Downloading Apache Tomcat************"
   echo "==============================================="
   wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.33/bin/apache-tomcat-10.1.33.tar.gz
   echo "======================================================="   
   echo "==========Extracting Apache Tomcat files==============="
   echo "======================================================="   
   tar -xzf apache-tomcat-10.1.33.tar.gz >/dev/null;rm -rf apache-tomcat-10.1.33.tar.gz;chmod -R 755 apache-tomcat-10.1.33
fi
if [ -f ~/apache-tomcat-10.1.33/webapps/jenkins.war ]
then
   echo "========================================"
   echo "******jenkins.war already exists********"
   echo "========================================" 
else
   echo "===================================================="
   echo "***********Downloading jenkins war file*************"
   echo "===================================================="
      cd ~/apache-tomcat-10.1.33/webapps; wget https://get.jenkins.io/war-stable/2.479.2/jenkins.war
fi

if [ $tomcat_process -gt 1 ]
then
   echo "================================================"
   echo "***tomcat-apache service is already running*****"
   echo "================================================"
else
   echo "================================================"
   echo "********Starting tomcat apache service**********"
   echo "================================================"
   cd /root/apache-tomcat-10.1.33/bin; ./startup.sh
fi


echo "===================================================================="
echo "Please use this url to access jenkins http://$public_ip:8080/jenkins"
echo "===================================================================="
echo "******Your initial Jenkins password is : $jenkins_initial_pwd ******"
echo "===================================================================="


echo "==============================================="
echo "**********Jenkins setup is completed***********"
echo "==============================================="
