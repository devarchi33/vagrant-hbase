#!/bin/bash

# 현재 폴더위치 구하기.
this="${BASH_SOURCE-$0}"
while [ -h "$this" ]; do
  ls=`ls -ld "$this"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    this="$link"
  else
    this=`dirname "$this"`/"$link"
  fi
done

## convert relative path to absolute path
bin=`dirname "$this"`
script=`basename "$this"`
bin=`cd "$bin">/dev/null; pwd`
this="$bin/$script"

BASE_DIR=`dirname $this`
JavaSet_FILE="JavaSet.tar"

sudo cp /vagrant/profile /etc/profile
source /etc/profile

#현재 위치에 설치파일 유무 체크
function func_check_JavaSet
{
  if [ -s $BASE_DIR/$JavaSet_FILE ]; then
	echo "true"
  else
	echo "false"
  fi	
}

#파일 체크하여 다운로드
function func_download_JavaSet
{
  check_exist_JavaSet=$(func_check_JavaSet)
  if [[ "$check_exist_JavaSet" == "true"  ]]; then
	echo "Already downloaded JavaSet.tar..."
  else
	echo "JavaSet.tar not detected! downloading JavaSet.tar"
	wget https://s3-ap-northeast-1.amazonaws.com/devarchi33-pinpoint/JavaSet.tar
  fi
}

func_download_JavaSet

#Java 설치
function func_install_java
{
  tar -xvf JavaSet.tar
  sudo JavaSet/jdk-6u45-linux-x64-rpm.bin
  sudo mv /usr/java/jdk1.6.0_45 /usr/local
  sudo ln -s /usr/local/jdk1.6.0_45 /usr/local/java6
  sudo tar -xvf JavaSet/jdk-7u79-linux-x64.gz -C /usr/local
  sudo ln -s /usr/local/jdk1.7.0_79 /usr/local/java7
  sudo tar -xvf JavaSet/jdk-8u65-linux-x64.gz -C /usr/local
  sudo ln -s /usr/local/jdk1.8.0_65 /usr/local/java8
  sudo tar -xvf JavaSet/apache-maven-3.3.9-bin.tar.gz -C /usr/local
  sudo ln -s /usr/local/apache-maven-3.3.9 /usr/local/maven3.3
  rm -rf *.rpm
}

#Java 설치 유무 체크하여 진행
function func_check_java_install 
{
  if [ -d "/usr/local/java6"  ]; then
	echo "Already installed java."
  else 
	echo "Installing java..."
	func_install_java
  fi
}

func_check_java_install
