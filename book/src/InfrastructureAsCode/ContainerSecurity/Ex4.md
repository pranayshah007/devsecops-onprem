# Docker - Cgroups

* Create a docker container using an alpine image and allocate cpu 1 to it and run the ```dd if=/dev/zero of=/dev/null``` command.

```bash
docker run -d --name='cpu-limit-high' --cpus='1' alpine dd if=/dev/zero of=/dev/null
```
* Create another similar container, but allocate cpu 0.5 to it.
```bash
docker run -d --name='cpu-limit-low' --cpus='0.5' alpine dd if=/dev/zero of=/dev/null
```

##### Note: /dev/zero provides an endless stream of zero bytes when read. This function is provided by the kernel and does not require allocating memory. All writes to /dev/null are dropped silently. "dd" sends data from input file to outputfile

* Run ```docker ps``` to list the running containers.

Output:
```bash
pentester@NotSoSecure:~$ docker run -d --name='cpu-limit-high' --cpus='1' alpine dd if=/dev/zero of=/dev/null
dd19cca9eac9837e978f5b52f5f95569a0e78280ffa72f337c0236c146ce90bf
pentester@NotSoSecure:~$ docker run -d --name='cpu-limit-low' --cpus='0.5' alpine dd if=/dev/zero of=/dev/null
adfeac68306b22d78bb55da64e5724a251ff6de1df4404ed474bae5751fa2bbe
pentester@NotSoSecure:~$ docker ps
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                       NAMES
adfeac68306b   alpine          "dd if=/dev/zero of=…"   4 seconds ago    Up 3 seconds                                                cpu-limit-low
dd19cca9eac9   alpine          "dd if=/dev/zero of=…"   22 seconds ago   Up 20 seconds                                               cpu-limit-high
b68eb865b168   alpine          "sleep 10d"              16 minutes ago   Up 16 minutes                                               naughty_turing
92b55ca1a1a5   tomcat-sample   "catalina.sh run"        28 minutes ago   Up 28 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   amazing_spence
pentester@NotSoSecure:~$
```
* Run pgrep to identify the process IDS for each of the process ```dd if /dev/zero of /dev/null```

```bash
pgrep -a dd
```
Output:
```
pentester@NotSoSecure:~$ pgrep -a dd
2 kthreadd
96 ipv6_addrconf
4496 dd if /dev/zero of /dev/null
4606 dd if /dev/zero of /dev/null
pentester@NotSoSecure:~$
```
* Run top for both the Process-IDS identified above:
```bash
top -p <PID-1>,<PID-2>
```
Output:
```
pentester@NotSoSecure:~$ top -p 4496, 4606
top - 08:58:42 up  2:38,  2 users,  load average: 1.37, 1.45, 1.01
Tasks:   2 total,   2 running,   0 sleeping,   0 stopped,   0 zombie
%Cpu(s): 14.1 us, 61.0 sy,  0.0 ni, 24.9 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  1008508 total,   600192 free,   250284 used,   158032 buff/cache
KiB Swap:  2097148 total,  2091248 free,     5900 used.   615788 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 4496 root      20   0    1596      4      0 R 100.0  0.0  15:10.56 dd
 4606 root      20   0    1596      4      0 R  50.3  0.0   7:28.34 dd
```
