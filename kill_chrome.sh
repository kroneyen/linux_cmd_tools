#!/bin/sh

ps -ef | grep 'chrome' | grep -v grep | awk '{print $2}'
echo "======================"
sleep 1
ps -ef | grep 'chrome' | grep -v grep | awk '{print $2}' | xargs  --no-run-if-empty kill -9 
sleep 1
echo "kill done !!"
