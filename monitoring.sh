#!/bin/bash

# wall has no color support
c1='\033[0;31m' # red
c2='\033[0;34m' # blue
nc='\033[0m'    # no color

# Same as `uname -m`
arch=$(arch)
kver=$(uname -r)
socket_count=$(lscpu | grep "Socket(s):" | awk '{print $2}')
cpu_count=$(lscpu | grep "^CPU(s):" | awk '{print $2}')

# Triple chevrons are called "here strings"
read -r ram_size ram_used <<< $(free -h | grep ^Mem: | awk '{print $2,$3}')

# Calculate percentage without floating point precision
ram_usage=$(free | grep ^Mem: | awk '{printf "%.f", ($3/$2)*100}')

# Get everything in one go
read -r disk_size disk_used disk_usage <<< $(df -h --total | grep ^total | awk '{print $2,$3,$5}')

# Not the most accurate estimation
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')
boot_time=$(who -b | awk '{print $3,$4}')

# Quiet grep any match "."
lvm_enabled=$(lvscan | grep -q . && echo "yes" || echo "no")

# Substract one line for the table titles
tcp_count=$(ss -ta state established | wc -l | awk '{print $1-1}')
active_users=$(who -u | wc -l)

# Find the default device?
device=$(ip route | grep default | awk '{print $5}')
ip_addr=$(ip -br addr show $device | awk '{print $3}')
mac_addr=$(ip -br link show $device | awk '{print $3}')

# Need to silence stderr
sudo_cmds=$(journalctl _COMM=sudo 2>/dev/null | grep COMMAND= | wc -l)

mapfile -t info <<EOF

architecture     ${arch}
kernel           ${kver}
cpus             ${socket_count}
vcpus            ${cpu_count}
ram usage        ${ram_used} / ${ram_size} (${ram_usage}%)
disk usage       ${disk_used} / ${disk_size} (${disk_usage})
cpu load         ${cpu_usage}%
last reboot      ${boot_time}
lvm active       ${lvm_enabled}
tcp connections  ${tcp_count}
users            ${active_users}
ipv4             ${ip_addr}
mac              ${mac_addr}
sudo             ${sudo_cmds}
EOF

mapfile -t ascii <<'EOF'

       _,met$$$$$gg.
    ,g$$$$$$$$$$$$$$$P.
  ,g$$P"        """Y$$.".
 ,$$P'              `$$$.
',$$P       ,ggs.     `$$b:
`d$$'     ,$P"'   .    $$$
 $$P      d$'     ,    $$P
 $$:      $$.   -    ,d$$'
 $$;      Y$b._   _,d$P'
 Y$$.    `.`"Y$$$$P"'
 `$$b      "-.__
  `Y$$
   `Y$$.
     `$$b.
       `Y$$b.
          `"Y$b._
              `"""

EOF

# Note: wall sends a message on all terminals and the message will wrap around
# if it exceeds the terminal length (80 characters is common)
{
for i in "${!ascii[@]}"; do
	printf "%-30s %s\n" "${ascii[i]}" "${info[i]}"
done
} | wall
