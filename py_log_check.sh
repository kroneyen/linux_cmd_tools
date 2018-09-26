#!/bin/sh

_file='/root/python_dir'
_list=('p2plogin' 'apklogin' 'kingbus')

for list in "${_list[@]}";do

  _path=${_file}/${list}
  cd ${_path} 
  if [ ${list} == 'p2plogin' ];then
     _strr="p2p*.log"     
  else 
     _strr="*.log"
  fi
  
  #IFS=', ' read -r -a _logs <<< `ls -al $_strr | awk '{print $9}'`
  read -r -a _logs <<< `ls -al $_strr | awk '{print $9}'`  ##into array

  for log in "${_logs[@]}" 
  do
     echo $log
     echo "======= start ======="
     tail -n45 ${log} | while read line || [[ -n "$line" ]]; do
      echo $line
     done
     #sleep 1
     echo "======= done  ======"
     echo "                    "
  done

done
