
#!/bin/sh

THRESHOLD_MB=5000
NOWDATE=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$1

TOTAL_MEM=$(free -m | awk '/^Mem:/ {print $2}')
USED_MEM=$(free -m | awk '/^Mem:/ {print $3}')
AVAILABLE_MEM=$(free -m | awk '/^Mem:/ {print $7}')
LOAD_AVG=$(cat /proc/loadavg | awk '{print $1, $2, $3}')  # 1-min, 5-min, 15-min load

echo "Available MEM: $AVAILABLE_MEM"

if [ "$AVAILABLE_MEM" -lt "$THRESHOLD_MB" ]; then
    echo "MEM is below then $THRESHOLD_MB value"
    summary=$(echo "Hi Team,

Please find the high memory consumption taken by below application on $HOSTNAME.

Total Memory     : ${TOTAL_MEM} MB
Used Memory      : ${USED_MEM} MB
Available Memory : ${AVAILABLE_MEM} MB
Load Average     : ${LOAD_AVG}

Top 20 Memory-Consuming Unique Commands:

$(ps -eo pid,%mem,args --no-headers | \
awk '
{
    mem_key = ""
    for (i=3; i<=NF; i++) {
        mem_key = mem_key $i " "
    }
    sub(/[ \t]+$/, "", mem_key)
    mem[mem_key] += $2
    count[mem_key]++
}
END {
    for (cmd in mem) {
        printf "%.2f|%d|%s\n", mem[cmd], count[cmd], cmd
    }
}' | \
sort -t'|' -k1 -nr | head -n 20 | \
while IFS='|' read memsum count command; do
    echo "Command            : $command"
    echo "Instances Running  : $count"
    echo "Total %MEM Used    : $memsum"
    echo "---------------------------------------"
done
)")

    # Save top 100 process snapshot
    top_file="/tmp/top_processes.txt"
    ps aux --sort=-%mem | head -150 > "$top_file"

    # Send email with attachment using uuencode
    {
        echo "$summary"
        echo ""
        uuencode "$top_file" "top_processes.txt"
    } | mail -s "$HOSTNAME - Memory Alert - High Consumption - (Available: ${AVAILABLE_MEM}MB) - $NOWDATE" devops.surbo@vfirst.com -a 'From: mem_alert@vfirst.com'

    # Clean up
    rm -f "$top_file"

    webhook_alert "$1 - $(hostname -I) - Memory Alert - Current Mem -$AVAILABLE_MEM -- High Consumption"
fi
