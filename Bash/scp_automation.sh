#!/bin/bash

#HOST=対象ホスト名(IPアドレス)
#USER=ログインユーザ
#PASS=パスワード
#TARGET_DIR=バックアップディレクトリ(ファイル)
#BACKUP_DIR=保存先ディレクトリ

HOST=HOST_NAME
USER=USER
PASS=PASSWD
TARGET_DIR=/path/to/target_dir
BACKUP_DIR=/pass/to/backup_dir

expect -c "
set timeout 60
spawn scp -P20022 ${USER}@${HOST}:${TARGET_DIR} ${BACKUP_DIR}
expect {
\" Are you sure you want to continue connecting (yes/no)? \" {
send \"yes\r\"
expect \"password:\"
send \"${PASS}\r\"
} \"password:\" {
send \"${PASS}\r\"
}
}
interact
"
