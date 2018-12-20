#!/bin/sh

_file='/root/python_dir'
_list=('p2plogin' 'apklogin' 'awabest' 'kingbus')

for index in "${!_list[@]}";do  ## length:${#_file[@]} , index:${!_file[@]}

  _path=${_file}/${_list[index]}
  _strr='*.log' 
  _v_strr='history\|test' ## except word
  
  cd ${_path} 
  read -r -a _logs <<< `ls -al ${_strr} | awk '{print $9}' | grep -v ${_v_strr}`  ## find log name into array

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
