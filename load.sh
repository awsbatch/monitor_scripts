
#!/bin/bash

THRESHOLD_LOAD=6.0
NOWDATE=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$1
NPROC=$(nproc)

LOAD_AVG=$(awk '{print $1, $2, $3}' /proc/loadavg)
LOAD_1MIN=$(echo "$LOAD_AVG" | awk '{print $1}')

echo "1-min Load Average: $LOAD_1MIN"

IS_HIGH=$(echo "$LOAD_1MIN > $THRESHOLD_LOAD" | bc)
if [ "$IS_HIGH" -eq 1 ]; then
    echo "Load is above threshold: $THRESHOLD_LOAD"

    summary=$(echo "Hi Team,

Please find the high CPU consumption taken by below application on $HOSTNAME.

CPU Cores          : $NPROC
1-min Load Average : $(echo "$LOAD_AVG" | awk '{print $1}')
5-min Load Average : $(echo "$LOAD_AVG" | awk '{print $2}')
15-min Load Average: $(echo "$LOAD_AVG" | awk '{print $3}')

Top 20 CPU-Consuming Unique Commands (Normalized by $NPROC cores):

$(ps -eo pid,%cpu,args --no-headers | \
awk -v nproc_val="$NPROC" '
{
    cpu_key = ""
    for (i=3; i<=NF; i++) {
        cpu_key = cpu_key $i " "
    }
    sub(/[ \t]+$/, "", cpu_key)
    cpu[cpu_key] += $2
    count[cpu_key]++
}
END {
    for (cmd in cpu) {
        normalized_cpu = cpu[cmd] / nproc_val
        printf "%.2f|%d|%.2f|%s\n", cpu[cmd], count[cmd], normalized_cpu, cmd
    }
}' | \
sort -t'|' -k1 -nr | head -n 20 | \
while IFS='|' read cpusum count normalized command; do
    echo "Command             : $command"
    echo "Instances Running   : $count"
    echo "Total %CPU Used     : $cpusum"
    echo "Normalized CPU Used : $normalized%"
    echo "---------------------------------------"
done
)")

    # Save top 150 CPU processes
    top_file="/tmp/top_cpu_processes.txt"
    ps aux --sort=-%cpu | head -150 > "$top_file"

    # Send email with summary and attachment
    {
        echo "$summary"
        echo ""
        uuencode "$top_file" "top_cpu_processes.txt"
    } | mail -s "$HOSTNAME - CPU Alert - Current Load (${LOAD_1MIN}) - $NOWDATE" devops.surbo@vfirst.com -a 'From: cpu_alert@vfirst.com'

    # Clean up
    rm -f "$top_file"

    webhook_alert "$1 - $(hostname -I) - LOAD/CPU Alert - Current Load -$LOAD_1MIN -- High Consumption"

fi
