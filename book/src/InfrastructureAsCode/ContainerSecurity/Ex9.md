# Use cosign to generate public and private keys to sign and verify container images

**Command**
```
cd 
mkdir cosign
cd cosign
cosign generate-key-pair
```
**Output**
```
Enter password for private key: 
Enter password for private key again: 
Private key written to cosign.key
Public key written to cosign.pub
```
**Command**
```
ls
```
**Output**
```
cosign.key  cosign.pub
```
Now, let's host a local docker registry to store signed container images.

**Command**
```
docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
**Output**
```
7db0b1306f4bea61ad75e50dd15d822d5c1bdad880117bb4b8526d1ee760ef7d
```
**Command**
```
docker ps
```
**Output**
```
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                       NAMES
54a70fb9540e   registry:2   "/entrypoint.sh /etc…"   7 seconds ago   Up 6 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry
```
Lets upload a alpine image from docker to local registry with tag 'signed'

**Command**
```
docker pull alpine
```
**Output**
```
Using default tag: latest
latest: Pulling from library/alpine
59bf1c3509f3: Pull complete 
Digest: sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
```
**Command**
```
docker tag alpine localhost:5000/alpine:signed
```
**Command**
```
docker push localhost:5000/alpine:signed
```
**Output**
```
The push refers to repository [localhost:5000/alpine]
8d3ac3489996: Pushed 
signed: digest: sha256:e7d88de73db3d3fd9b2d63aa7f447a10fd0220b7cbf39803c803f2af9ba256b3 size: 528
```

We can now sign the container image 'alpine:signed' present in local registry

**Command**
```
cosign sign --key cosign.key localhost:5000/alpine:signed
```
**Output**
```
Enter password for private key: 
Pushing signature to: localhost:5000/alpine
```
We can verify signature of 'alpine:signed' present in local registry using public key

**Command**
```
cosign verify --key cosign.pub localhost:5000/alpine:signed
```
**Output**
```
Verification for localhost:5000/alpine:signed --
The following checks were performed on each of these signatures:
`  `- The cosign claims were validated
`  `- The signatures were verified against the specified public key

[{"critical":{"identity":{"docker-reference":"localhost:5000/alpine"},"image":{"docker-manifest-digest":"sha256:e7d88de73db3d3fd9b2d63aa7f447a10fd0220b7cbf39803c803f2af9ba256b3"},"type":"cosign container image signature"},"optional":null}]
```

### **Deleting local registry**
Process to remove local container registry

**Command**
```
docker ps
```
**Output**
```
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS          PORTS                                       NAMES
54a70fb9540e   registry:2   "/entrypoint.sh /etc…"   11 minutes ago   Up 11 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry
```
**Command**
```
docker rm -f registry
```
**Output**
```
registry
```