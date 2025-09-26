
# Webhook function
webhook_alert() {
  local message="$1"
  local webhook_url="https://valuefirst.webhook.office.com/webhookb2/cef31364-148e-460a-84a2-8791275d5c37@dd58fdca-ddf7-4ca1-b5a4-e3a1d6e19191/IncomingWebhook/7f0421d36fc4423b9e92190a2a160ebf/963a6bdd-a87e-439b-8cc4-3bc7d94b77bf/V2qFqFDp5a1Nj1TII5lkXgZKJ6VXJ0VoCBsTUKhNxPVLQ1"

  curl -H "Content-Type: application/json" \
       -d "{\"text\": \"$message\"}" \
       "$webhook_url"
}

# Get disk usage for / partition
df_output=$(df -hP / | awk 'NR==2')
df_output_raw=$(df -P / | awk 'NR==2')

# Human-readable values
size_disk=$(echo "$df_output" | awk '{print $2}')
used_disk=$(echo "$df_output" | awk '{print $3}')
available_disk=$(echo "$df_output" | awk '{print $4}')
used_percent=$(echo "$df_output" | awk '{print $5}' | tr -d '%')

# Raw KB values for precision math
size_kb=$(echo "$df_output_raw" | awk '{print $2}')
avail_kb=$(echo "$df_output_raw" | awk '{print $4}')

# Calculate available percent
available_percent=$(echo "scale=2; $avail_kb * 100 / $size_kb" | bc)

# Print header and info
echo -e "\n💾 ${YELLOW}Disk Usage for / Partition${RESET}"
echo "================================================================================"
printf "Disk Size       : ${YELLOW}%-10s${RESET}\n" "$size_disk"
printf "Used Space      : ${YELLOW}%-10s${RESET} (%s%%)\n" "$used_disk" "$used_percent"
printf "Available Space : ${YELLOW}%-10s${RESET} (%.2f%%)\n" "$available_disk" "$available_percent"

# Check threshold and trigger webhook if needed
if [ "$used_percent" -ge 80 ]; then
  echo -e "\n⚠️  Disk usage is above 80%. Executing webhook_alert..."

  message="\`\`\`
💾 Disk Usage Alert on / Partition from $1 Server


Disk Size       : $size_disk
Used Space      : $used_disk (${used_percent}%)
Available Space : $available_disk (${available_percent}%)
\`\`\`"

webhook_alert "$message"
mail_subject="Disk Usage Alert on / Partition from $1"
mail_body="Disk Usage Alert on / Partition from $1 Server

Disk Size       : $size_disk
Used Space      : $used_disk (${used_percent}%)
Available Space : $available_disk (${available_percent}%)"

  echo "$mail_body" | mail -s "$mail_subject" devops.surbo@vfirst.com
fi
