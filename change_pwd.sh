#!/bin/sh

## _file && _file_git must be mapping 
## _ch_pwd 
_file=('XXXX_linux.py')
_file_git=('XXXX_linux_git.py')
_ch_pwd=('AAAA' 'ZZZZ') 
## use regex exp: A004A[TU][0-9]*[a-Z]*

for index in ${!_file[@]} ;do ## length:${#_file[@]} , index:${!_file[@]}
  #echo ${lists[index]} , ${list_gits[index]}
  ## cp file
  /usr/bin/cp ${_file[index]} ${_file_git[index]}
  echo "cp done!!"

  ## ch_accout_pwd
  echo "clean up done!!"
  for ch_index in ${!_ch_pwd[@]};do  ## get index from:0 
     ## change _ch_pwd list 
    /usr/bin/sed -i -e "s/${_ch_pwd[ch_index]}/XXXXXXXX/g" ${_file_git[index]}
    echo "${_ch_pwd[ch_index]} is change done"
  done


done
