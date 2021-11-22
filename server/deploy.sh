#!/bin/bash

REPOSITORY=/home/ubuntu/apps/HungryApp
JAR=/home/ubuntu/apps/

cd $REPOSITORY

echo "> Git Pull"

git pull

echo "> Start Spring Boot jar Build"

./gradlew build

echo "> Copy jar"

cp ./build/libs/*.jar $JAR/

echo "> check current running server pid"

CURRENT_PID=$(pgrep -f springboot-webservice)

echo "$CURRENT_PID"

if [ -z $CURRENT_PID ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -2 $CURRENT_PID"
    kill -9 $CURRENT_PID
    sleep 5
fi

echo "> run new jar"

JAR_NAME=$(ls $JAR/ |grep 'springboot-webservice' | tail -n 1)

echo "> JAR Name: $JAR_NAME"

nohup java -jar $JAR/$JAR_NAME &
