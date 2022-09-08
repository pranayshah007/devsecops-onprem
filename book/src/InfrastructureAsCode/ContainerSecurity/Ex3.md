# Docker Namespaces

* Run a docker container using an alpine image and run the sleep command
 ```bash
 docker run -d alpine sleep 10d
 ```
 
* Then run ```docker ps``` to list the Running containers.
Output:
```
 pentester@NotSoSecure:/tmp/tomcat-sample$ docker run -d alpine sleep 10d
b68eb865b1680bcefd46b717861f3fb57a597590a0b94addf3de6efeafac9214
pentester@NotSoSecure:/tmp/tomcat-sample$ docker ps
CONTAINER ID   IMAGE           COMMAND             CREATED          STATUS          PORTS                                       NAMES
b68eb865b168   alpine          "sleep 10d"         4 seconds ago    Up 2 seconds                                                naughty_turing
92b55ca1a1a5   tomcat-sample   "catalina.sh run"   12 minutes ago   Up 12 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   amazing_spence 
 ```
 * Exec into the newly created alpine container: and then run ```ps``` to identify the processes.

  ```bash
  docker exec -it <Container_ID> sh
  ```

 * In the Alpine container terminal run ```ps``` and note the process ID of the sleep command

Output:
```
pentester@NotSoSecure:/tmp/tomcat-sample$ docker exec -it b68 sh
/ # ps
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 10d
   14 root      0:00 sh
   20 root      0:00 ps
/ # exit
pentester@NotSoSecure:/tmp/tomcat-sample$
```
* Now identify the process ID of the sleep command in the host(VM) by running The following:
 ```bash
ps -aux | grep sleep
 ```
 Output:
 ```bash
 pentester@NotSoSecure:/tmp/tomcat-sample$ ps -aux | grep sleep
root      4264  0.1  0.0   1596     4 ?        Ss   08:27   0:00 sleep 10d
pentest+  4389  0.0  0.0  14436   992 pts/0    S+   08:29   0:00 grep --color=auto sleep
 ```
 * Now identify the namespaces by running the following:
 ```bash
 sudo ls -la /proc/<Process_ID>/ns
 ```
 Output:
 ```
 pentester@NotSoSecure:/tmp/tomcat-sample$ sudo ls -la /proc/4264/ns
total 0
dr-x--x--x 2 root root 0 Sep  2 08:27 .
dr-xr-xr-x 9 root root 0 Sep  2 08:27 ..
lrwxrwxrwx 1 root root 0 Sep  2 08:29 cgroup -> 'cgroup:[4026531835]'
lrwxrwxrwx 1 root root 0 Sep  2 08:28 ipc -> 'ipc:[4026532304]'
lrwxrwxrwx 1 root root 0 Sep  2 08:28 mnt -> 'mnt:[4026532302]'
lrwxrwxrwx 1 root root 0 Sep  2 08:27 net -> 'net:[4026532307]'
lrwxrwxrwx 1 root root 0 Sep  2 08:28 pid -> 'pid:[4026532305]'
lrwxrwxrwx 1 root root 0 Sep  2 08:29 pid_for_children -> 'pid:[4026532305]'
lrwxrwxrwx 1 root root 0 Sep  2 08:29 user -> 'user:[4026531837]'
lrwxrwxrwx 1 root root 0 Sep  2 08:28 uts -> 'uts:[4026532303]'
pentester@NotSoSecure:/tmp/tomcat-sample$

 ```