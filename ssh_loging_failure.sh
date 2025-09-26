
#!/bin/bash
server=1
ldate1=`date --date '-1 min' '+%b %d %R'`
ldate15=`date --date '-15 min' '+%b %d %R'`
filep=/var/log/auth.log
logg=/script/monitor_scripts/alert.logs
logg15=/script/monitor_scripts/last15min.logs
awk -v d1="$(date --date="-15 min" "+%b %_d %H:%M")" -v d2="$(date "+%b %_d %H:%M")" '$0 > d1 && $0 < d2 || $0 ~ d2' $filep > $logg15
faa=`cat $logg15 | grep "error: PAM: Authentication failure" |grep -v "illegal" | wc -l`
ifa=`cat $logg15 | grep "illegal" | grep "error: PAM: Authentication failure" | uniq -c | sort -nr| wc -l`
iur=`cat $logg15 | grep "Invalid" | awk '{print $8,$10}' | wc -l`

count=` cat /script/monitor_scripts/last15min.logs | grep 'Invalid\|PAM: Authentication failure' | wc -l `
echo $count
if [ $count -ge 1 ]
then
echo "Hi Team," > $logg
echo "" >> $logg
echo "Please find the details of Invalid & Failure Attempts on server $1 between $ldate15 to $ldate1" >> $logg
echo "" >> $logg
echo "--> Total Failed Attempts from Valid Users = $faa" >> $logg
echo "" >> $logg
echo "--> Total failure attempts from Invalid Users = $ifa" >>$logg
echo "" >> $logg
echo "--> Total Invalid User = $iur" >>$logg
echo "" >> $logg
echo "--------------Last 15 min Failure Attempts on $1 Server ----------------" >> $logg
echo "" >> $logg
# failed Password
echo "------------Failed Attempts for Valid User -----------------" >> $logg
cat $logg15 | grep "error: PAM: Authentication failure" |grep -v "illegal" | awk '{print $11,$13}' | uniq -c | sort -nr >> $logg
# Invalid User
echo "" >> $logg
