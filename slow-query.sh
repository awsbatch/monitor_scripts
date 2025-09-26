#!/bin/bash

date=`date --date= +%d-%B-%Y`
tdate=`date --date= +%Y%m%d`
last_min=`date --date '-1 min' '+%Y-%m-%dT%R'`
mkdir -p /scripts/slow_logs/
log_file=/scripts/slow_logs/slow_$last_min.log
echo ---- apt-get update---- > $log_file
#apt-get update  >> $log_file
echo ---- apt-get sharutils---- >> $log_file
#apt-get install sharutils >> $log_file
echo $last_min

cd /var/log/mysql
slow_count=`cat mysql-slow.log | grep -iA5 "$last_min"  | grep Query_time | awk '$3 > 4.1' | wc -l`
#slow_count=`cat mysql-slow.log | grep -iA5 "$last_min"  | grep Query_time | awk '$3' > 2 | wc -l`
echo $slow_count

totquer=`cat mysql-slow.log | grep -iA5 "$last_min" | grep Query_time | awk '$3 > 4.1' | awk '{print $3}' | cut -d "." -f1 | sort -n | uniq -c | perl -p -e 's/^ *//' | column -t |  awk '{print $1" taking " $2}' | sed 's/^/Total Queries--/'| sed 's/$/--Seconds/'`

prntslow=`cat mysql-slow.log | grep -iA5 "$last_min" | awk '$3 > 4.1' | grep -A3 Query_time > $log_file`

if [ $slow_count -ge 1 ]
then

( printf '%s\n\n' "Hi Team"
printf '%s\n\n' "Please find the Slow Queries in brief -- INDIA DB-1 MYQSL DB-Master Server"
printf '%s\n' " Total Slow queries in last min which taking more than (4sec) -- $slow_count no."
printf '%s\n' " "
printf '%s\n' " Total numbers of queries list are as follows:"
printf '%s\n' "  $totquer"
printf '%s\n' " "
printf '%s\n' "Queries are attached"
printf '%s\n' " "
printf '%s\n' " "
uuencode $log_file $log_file_.txt;
) |/usr/bin/mail -s "INDIA DB-1 MYSQL -- SLOW QUERIES ABOVE THAN 4 SEC $last_min  " devops.surbo@vfirst.com -a 'From: dbcritical@vfirst.com'

fi
