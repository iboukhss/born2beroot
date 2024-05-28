#!/bin/bash

c1='\033[0;31m' # red
c2='\033[0;34m' # bluex
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
mem (total)
mem (avail)
cpu (usage)
last reboot
lvm
connections
users
ip
sudo
EOF

mapfile -t info <<EOF

$(arch)
$(uname -r)
$(lscpu | awk '/Socket\(s\):/ {print $2}')
$(lscpu | awk '/^CPU\(s\):/ {print $2}')
$(free -h | awk '/^Mem:/ {print $2}')
$(free -h | awk '/^Mem:/ {print $7}')

$(who -b | awk '{print $3,$4}')
$()
$()
$()
$()
$()
EOF

for i in {0..18}; do
	printf "${c2}%-27s${nc} ${c1}%-11s${nc} %s\n" "${ascii[i]}" "${labels[i]}" "${info[i]}"
done
