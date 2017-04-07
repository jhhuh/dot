#!/usr/bin/env bash

LOG_FILE=cabal_build.log
echo "inotifywait starts" > $LOG_FILE

while inotifywait -e CLOSE_WRITE -e DELETE_SELF -r ./src ./*.cabal > /dev/null 2>&1; do
    cabal build >> $LOG_FILE 2>&1
    echo '******************************' >> $LOG_FILE 2>&1
    cabal run >> $LOG_FILE 2>&1
done
