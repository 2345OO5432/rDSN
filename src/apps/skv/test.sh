#!/bin/bash

if [ ! -f dsn.app.simple_kv ]; then
    echo "dsn.app.simple_kv not exist"
    exit -1
fi

rm -rf data core* out

echo "running dsn.app.simple_kv for 30 seconds ..."
./dsn.app.simple_kv config.ini &>out &
PID=$!
sleep 30
kill $PID

if [ -f core ] || ! grep ERR_OK out; then
    echo "run dsn.app.simple_kv failed"
    echo "---- ls ----"
    ls -l
    echo "---- head -n 100 out ----"
    head -n 100 out
    if [ -f data/logs/log.1.txt ]; then
        echo "---- tail -n 100 log.1.txt ----"
        tail -n 100 data/logs/log.1.txt
    fi
    if [ -f core ]; then
        echo "---- gdb ./dsn.app.simple_kv core ----"
        gdb ./dsn.app.simple_kv core -ex "thread apply all bt" -ex "set pagination 0" -batch
    fi
    exit -1
fi

echo "run dsn.app.simple_kv succeed"

