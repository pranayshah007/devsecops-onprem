# Run a docker container using an alpine image

* Run the below command:

```bash 
docker run --rm -it alpine /bin/sh 
```

Output:

```
pentester@NotSoSecure:~$ docker run --rm -it alpine /bin/sh
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
213ec9aee27d: Pull complete
Digest: sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
Status: Downloaded newer image for alpine:latest
/ # 
```

* Then run the following inside the alpine terminal:

```bash
ps aux
```

Output:

```
Output:
/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /bin/sh
    8 root      0:00 ps aux
```


* You can view the cgroups by running:

```bash
cat /proc/1/cgroup
```

Output:

```
/ # cat /proc/1/cgroup
12:freezer:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
11:cpuset:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
10:perf_event:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
9:memory:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
8:pids:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
7:cpu,cpuacct:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
6:blkio:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
5:net_cls,net_prio:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
4:rdma:/
3:devices:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
2:hugetlb:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
1:name=systemd:/docker/d99ec46a1cf221c37f90afbb4b63d7d65ea5f0a31aad939e6cafd6c0b0db5894
0::/system.slice/containerd.service

```