#!/bin/bash

c1='\033[0;31m' # red
c2='\033[0;34m' # blue
nc='\033[0m'    # no color

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

mapfile -t labels <<'EOF'
arch
kernel
cpus
vcpus
ram
disk
cpu
last reboot
lvm
connections
users
ip
sudo
EOF

device=$(ip route | grep default | awk '{print $5}')
ip_addr=$(ip -br addr show $device | awk '{print $3}')
mac_addr=$(ip -br link show $device | awk '{print $3}')

mapfile -t info <<EOF
$(arch)
$(uname -r)
$(lscpu | grep "Socket(s):" | awk '{print $2}')
$(lscpu | grep "^CPU(s):" | awk '{print $2}')
$(free -h | grep ^Mem: | awk '{printf "%s / %s (%.f%%)", $3, $2, ($3/$2)*100}')
$(df -h --total | grep ^total | awk '{printf "%s / %s (%s)", $3, $2, $5}')
$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4 "%"}')
$(who -b | awk '{print $3, $4}')
$(lvscan > /dev/null 2>&1 && echo "yes" || echo "no")
$(netstat -a | grep ESTABLISHED | wc -l)
$(who -u | wc -l)
${ip_addr} (${mac_addr})
$(journalctl _COMM=sudo | grep COMMAND= | wc -l)
EOF

{
for i in "${!ascii[@]}"; do
	printf "%-30s %-12s %s\n" "${ascii[i]}" "${labels[i]}" "${info[i]}"
done
} | wall
