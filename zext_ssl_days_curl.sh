#!/bin/sh
#------------------------------------------------------------
# zext_ssl_days_curl.sh
# Script checks for number of days until certificate expires
#
# Based on script from aperto.fr (http://aperto.fr/cms/en/blog/15-blog-en/15-ssl-certificate-expiration-monitoring-with-zabbix.html)
# with additions by zmitrovic.vladislav@gmail.com
#------------------------------------------------------------

host=$1
proxy=$2


if [ -n "$host" ]
then
        if [ -n "$proxy" ]
        then
                options="$host -x $proxy"
        else
                options="$host"
        fi
        end_date=`curl --insecure -v $options 2>&1 | sed -n 's/ *expire date: *//p' | sed 's/*//g' | sed -e 's/^[ \t]*//'`

        if [ -n "$end_date" ]
        then
                end_date_seconds=`date '+%s' --date "$end_date"`
                now_seconds=`date '+%s'`
                echo "($end_date_seconds-$now_seconds)/24/3600" | bc
        else
                echo 0
        fi
else
        echo "usage: $0 hostname proxy:port"
        echo "Example: https://www.google.com"
fi
