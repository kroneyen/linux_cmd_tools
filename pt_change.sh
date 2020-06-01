#!/bin/bash
cnn_db=$1
table=$2
alter_conment=$3
cnn_host='localhost'
#cnn_user='user'
#cnn_pwd='password'
#cnn_db='database_name'
cnn_user='root'
cnn_pwd='123qweasd'
#cnn_db='krone
echo "DB: $cnn_db"
echo "TABLE: $table"
echo "CMD: $alter_conment"

pt-online-schema-change --user=${cnn_user} --password=${cnn_pwd} --host=${cnn_host}  P=3306,D=${cnn_db},t=$table --charset=utf8 --no-version-check --alter "${alter_conment}" --execute

###ALTER TABLE tb_test ADD COLUMN column1 tinyint(4) DEFAULT NULL;
###sh pt_change.sh krone initial_table "add column table_var1 int(11) unsigned NOT NULL DEFAULT '0' COMMENT '充值帳號' AFTER table_name"
