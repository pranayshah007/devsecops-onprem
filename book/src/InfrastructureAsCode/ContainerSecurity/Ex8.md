# Manually auditing a base image

- Victim.cloud attempted to play with docker and created <https://hub.docker.com/r/victimcloud/baseimage>
- Identify if there is any misconfigurations in the Image[s] using Dockle
- Use Dive to access the AWS credentials leaked in misconfigured container.
- Manually extract the files​


In this exercise we will try to identify misconfigurations present in container images in an automated mannner using opensource tool Dockle

Lets visit the “<https://hub.docker.com/r/victimcloud/baseimage/>” registry and observe the content present in it.

![img1](images/containers_solution_1_1.png)

We can observe the image name mentioned in docker pull command, let's try to audit image.

**Command**
```
dockle victimcloud/baseimage
```
**Output**
```
2022-03-09T20:10:55.423-0500	FATAL	unable to initialize a image struct: failed to initialize source: reading manifest latest in docker.io/victimcloud/baseimage: manifest unknown: manifest unknown|
```

so, as per dockle there is no image with latest tag in registry, Let's check tags section of this registry.

![img1](images/containers_solution_1_2.png)


There are 2 docker images present in the tags section i.e. “victimcloud/baseimage:v1” and “victimcloud/baseimage:v0.1”, lets audit image with tag v1

**Command**
```
dockle victimcloud/baseimage:v1
```
**Output**
```
FATAL	- DKL-DI-0004: Use "apk add" with --no-cache
	* Use --no-cache option if use 'apk add': /bin/sh -c apk --update add bash;
WARN	- CIS-DI-0001: Create a user for the container
	* Last user should not be root
INFO	- CIS-DI-0005: Enable Content trust for Docker
	* export DOCKER_CONTENT_TRUST=1 before docker pull/build
INFO	- CIS-DI-0006: Add HEALTHCHECK instruction to the container image
	* not found HEALTHCHECK statement
```

We can observe some misconfigurations present in the container image with tag v1, but there is no sign of leaked AWS credentials

Lets try to audit the image with tag v0.1 using dockle


**Command**
```
dockle victimcloud/baseimage:v0.1
```
**Output**
```
FATAL	- CIS-DI-0010: Do not store credential in environment variables/files
	* Suspicious filename found : root/.aws/credentials (You can suppress it with "-af credentials")
FATAL	- DKL-DI-0004: Use "apk add" with --no-cache
	* Use --no-cache option if use 'apk add': /bin/sh -c apk --update add bash;
WARN	- CIS-DI-0001: Create a user for the container
	* Last user should not be root
INFO	- CIS-DI-0005: Enable Content trust for Docker
	* export DOCKER_CONTENT_TRUST=1 before docker pull/build
INFO	- CIS-DI-0006: Add HEALTHCHECK instruction to the container image
	* not found HEALTHCHECK statement
```

And we are able to identify the aws credential file is leaked in container image with tag v0.1

lets pull victimcloud/baseimage:v0.1 image using docker pull

**Command**
```
docker pull victimcloud/baseimage:v0.1
```
**Output**
```
v0.1: Pulling from victimcloud/baseimage
aad63a933944: Pull complete 
22cd4173bfd5: Pull complete 
a02178bb2bba: Pull complete 
558fc96d284f: Pull complete 
Digest: sha256:7548d71a9fce9ec327e206e0e872f191b01f9282cc4b34529a6386c4d5edfee5
Status: Downloaded newer image for victimcloud/baseimage:v0.1
docker.io/victimcloud/baseimage:v0.1
```

We can use dive to investigate images in our VM and keys to use dive are

|**Key**|**Action**|
|---|---|
|Tab|Switch Panel|
|CTRL+U|Hide un-modified files|
|Space|Toggle entries|
|CTRL+C|Quit|

let's investigate the “victimcloud/baseimage:v0.1” 

**Commnad:**
```
dive victimcloud/baseimage:v0.1
```

![img1](images/containers_solution_1_3.png)

After hiding the un-modified files we can observe the presence of aws credentials file in the image's filesystem, we can try to get interactive shell of this docker image using below mentioned command 


**Command**
```
docker run --rm -it victimcloud/baseimage:v0.1 /bin/sh
```
**Output**
```
docker: Error response from daemon: failed to create shim: OCI runtime create failed: container\_linux.go:380: starting container process caused: exec: "/docker-entrypoint.sh": permission denied: unknown.
```

Looking at the error message we can conclude that we do not have access to the interactive shell of this image.
Ok, so we must use another method to get content present in the credentials file.
In this method we must save image to baseimage.tar using command mentioned below:

**Command**
```
mkdir dive1

cd dive1/

docker save victimcloud/baseimage:v0.1 -o baseimage.tar
```

Now, lets extract the file present in “baseimage.tar” file using command mentioned below

**Command**
```
tar -xvf baseimage.tar
```
**Output**
```
4d695754579b186b76ca352e07a4684144c2f81d732ae41361997623d3ec12c5.json
76ef45eb3ed25e5dd9c3c3c4127d7579a0be19941f5c6522da72a8460366598b/
76ef45eb3ed25e5dd9c3c3c4127d7579a0be19941f5c6522da72a8460366598b/VERSION
76ef45eb3ed25e5dd9c3c3c4127d7579a0be19941f5c6522da72a8460366598b/json
76ef45eb3ed25e5dd9c3c3c4127d7579a0be19941f5c6522da72a8460366598b/layer.tar
8fd40abec56bcc5c2b45b1a547f0d85564c2929dc82a184c63595eefcbfe3c83/
8fd40abec56bcc5c2b45b1a547f0d85564c2929dc82a184c63595eefcbfe3c83/VERSION
8fd40abec56bcc5c2b45b1a547f0d85564c2929dc82a184c63595eefcbfe3c83/json
8fd40abec56bcc5c2b45b1a547f0d85564c2929dc82a184c63595eefcbfe3c83/layer.tar
aa696fc1d3517d9dd627d0d7c0eabe3f0712a89f8cb1fc68218c0c60b371a6b9/
aa696fc1d3517d9dd627d0d7c0eabe3f0712a89f8cb1fc68218c0c60b371a6b9/VERSION
aa696fc1d3517d9dd627d0d7c0eabe3f0712a89f8cb1fc68218c0c60b371a6b9/json
aa696fc1d3517d9dd627d0d7c0eabe3f0712a89f8cb1fc68218c0c60b371a6b9/layer.tar
f3445783d86f83f660ae14bfef1f91a57ce05d87fd98e99743abf8ac1d37f906/
f3445783d86f83f660ae14bfef1f91a57ce05d87fd98e99743abf8ac1d37f906/VERSION
f3445783d86f83f660ae14bfef1f91a57ce05d87fd98e99743abf8ac1d37f906/json
f3445783d86f83f660ae14bfef1f91a57ce05d87fd98e99743abf8ac1d37f906/layer.tar
manifest.json
repositories
```

We have extracted the files present in the .tar file but to get aws credentials file we will have to navigate to the folder name which is identical to Layer id in “dive”.

Lets navigate to the identified folder and list contents present in this folder:

**Command**
```
cd 76ef45eb3ed25e5dd9c3c3c4127d7579a0be19941f5c6522da72a8460366598b/
```
List the files availble in the folder.
**Command**
```
ls -la
```

**Output**
```
total 20
drwxr-xr-x 2 root root 4096 Jul 28 2020 .
drwxr-xr-x 6 root root 4096 Mar 9 22:41 ..
-rw-r--r-- 1 root root 482 Jul 28 2020 json
-rw-r--r-- 1 root root 3584 Jul 28 2020 layer.tar
-rw-r--r-- 1 root root 3 Jul 28 2020 VERSION
```

We can observe the presence of the “layer.tar” file in this folder, lets extract the content present in this file.

**Command**
```
tar -xvf layer.tar
```

**Output**
```
root/
root/.aws/
root/.aws/.wh..wh..opq
root/.aws/credentials
```

We have found our illusive credentials file, let's check the content present in this file:


**Command**
```
cat root/.aws/credentials
```
**Output**
```
[s3_access]
AWS_ACCESS_KEY_ID=AKIA2QOCAU2POVC7TTFQ
AWS_SECRET_ACCESS_KEY=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
```