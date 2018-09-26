#!/bin/sh

_file='/root/python_dir'
_list=('p2plogin' 'apklogin' 'kingbus')

for index in "${!_list[@]}";do  ## length:${#_file[@]} , index:${!_file[@]}

  _path=${_file}/${_list[index]}
  cd ${_path} 
  if [ $index -eq 0 ];then
     _strr="p2p*.log"     
  else 
     _strr="*.log"
  fi
  read -r -a _logs <<< `ls -al $_strr | awk '{print $9}'`  ##into array

  for log in "${_logs[@]}" 
  do
     echo $log
     echo "======= start ======="
     tail -n45 ${log} | while read line ; do
      echo $line
     done
     #sleep 1
     echo "======= done  ======"
     echo "                    "
  done
done
