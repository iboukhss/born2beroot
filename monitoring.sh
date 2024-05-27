#!/bin/bash

c1='\033[0;31m' # red
c2='\033[0;34m' # blue
nc='\033[0m'    # no color

            read -rd '' ascii_data <<'EOF'
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

echo -e "${c2}$ascii_data${nc}"

# Same as `uname -m`
echo -e "${c1}arch${nc}        $(arch)"
echo -e "${c1}kernel${nc}      $(uname -r)"
echo -e "${c1}cpus${nc}        $(lscpu | awk '/Socket\(s\):/ {print $2}')"
echo -e "${c1}vcpus${nc}       $(lscpu | awk '/^CPU\(s\):/ {print $2}')"
echo -e "${c1}mem (total)${nc} $(free -h | awk '/^Mem:/ {print $2}')"
echo -e "${c1}mem (avail)${nc} $(free -h | awk '/^Mem:/ {print $7}')"
echo -e "${c1}cpu (usage)${nc}"
echo -e "${c1}last reboot${nc} $(who -b | awk '{print $3,$4}')"
echo -e "${c1}lvm${nc}         $()"
echo -e "${c1}connections${nc} $()"
echo -e "${c1}users${nc}       $()"
echo -e "${c1}ip${nc}          $()"
echo -e "${c1}sudo${nc}        $()"

