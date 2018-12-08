#!/bin/bash
newpasswd=$1;
export HISTIGNORE="expect*";
 
expect -c "
        spawn jupyter notebook password
        expect "?assword:"
        send \"$newpass\r\"
        expect "?assword:"
        send \"$newpass\r\"
        expect eof"
 
export HISTIGNORE="";
