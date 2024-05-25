# :seedling: Born2BeRoot

## :clipboard: Checklist

- [ ] SSH service on port 4242 (disable root access)
- [ ] Configure UFW to leave only port 4242 open
- [x] Set hostname to `iboukhss42`
- [ ] Implement strong password policy (see below)
- [ ] Install sudo following strict rules (see below)
- [x] Create user `iboukhss`
- [x] Add `iboukhss` to `user42` and `sudo` groups
- [ ] Create `monitoring.sh` script (see below)
- [ ] Turn in `signature.txt` (see below)

## :lock: Strong password policy

- Your password has to expire every 30 days.
- The minimum number of days allowed before the modification of a password will be set to 2.
- The user has to receive a warning message 7 days before their password expires.
- Your password must be at least 10 characters long. It must contain an uppercase letter, a lowercase letter, and a number. Also, it must not contain more than 3 consecutive identical characters.
- The password must not include the name of the user.
- The following rule does not apply to the root password: The password must have at least 7 characters that are not part of the former password.
- Of course, your root password has to comply with this policy.

## :shield: Strong sudo configuration

- Authentication using sudo has to be limited to 3 attempts in the event of an incorrect password.
- A custom message of your choice has to be displayed if an error due to a wrong password occurs when using sudo.
- Each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in the /var/log/sudo/ folder.
- The TTY mode has to be enabled for security reasons.
- For security reasons too, the paths that can be used by sudo must be restricted.  
Example: `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`

## :bar_chart: Monitoring script

At server startup, the script will display some information (listed below) on all terminals every 10 minutes (take a look at wall). The banner is optional. No error must be visible.

Your script must always be able to display the following information:

- The architecture of your operating system and its kernel version.
- The number of physical processors.
- The number of virtual processors.
- The current available RAM on your server and its utilization rate as a percentage.
- The current available memory on your server and its utilization rate as a percentage.
- The current utilization rate of your processors as a percentage.
- The date and time of the last reboot.
- Whether LVM is active or not.
- The number of active connections.
- The number of users using the server.
- The IPv4 address of your server and its MAC (Media Access Control) address.
- The number of commands executed with the sudo program.

## :memo: Signature file

You only have to turn in a `signature.txt` file at the root of your Git repository. You must paste in it the signature of your machine’s virtual disk. To get this signature, you first have to open the default installation folder (it is the folder where your VMs are saved):
- Windows: `HOMEDRIVE%%HOMEPATH%\VirtualBox VMs\`
- Linux: `/VirtualBox VMs/`
- MacM1: `/Library/Containers/com.utmapp.UTM/Data/Documents/`
- MacOS: `/VirtualBox VMs/`

Then, retrieve the signature from the ".vdi" file (or ".qcow2 for UTM’users) of your virtual machine in sha1 format. Below are 4 command examples for a `rocky_serv.vdi` file:
- Windows: `certUtil -hashfile rocky_serv.vdi sha1`
- Linux: `sha1sum rocky_serv.vdi`
- For Mac M1: `shasum rocky.utm/Images/disk-0.qcow2`
- MacOS: `shasum rocky_serv.vdi`

## Installation steps

- Get the latest [Debian stable ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso)
- Set hostname, username, strong passwords
- Setup LVM (guided partitioning with encryption)
- Uncheck GUI packages, keep web server, ssh server and system utilities

## Post installation steps

### Sudo

```console
apt install sudo
groupadd user42
usermod -aG sudo,user42 iboukhss
```

For more info read `man 5 sudoers`
```console
visudo

# This is default
Defaults	passwd_tries=3
Defaults	badpass_messaage="hehe xd"
Defaults	log_input,log_output
# How to force this?
Defaults	logfile="/var/log/sudo/sudo.log"
Defaults	requiretty
```

### Password policy

For more info read `man 5 login.defs`
```console
nano /etc/login.defs

PASS_MAX_DAYS	30
PASS_MIN_DAYS	2
PASS_WARN_AGE	7
```

For more info read `man 7 pam`



## During defense

