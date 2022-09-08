# Provision Lab Environment 

## Install terraform 

Download Terraform binary

```
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
```

Unzip Terraform zip file

```
unzip terraform_0.12.26_linux_amd64.zip
```

Copy terraform binary to bin folder

```
sudo cp terraform /usr/local/bin/
```

Run terraform command 

```
terraform
```

![gras](../../image/provisioning_lab/1.png)

***

## Infrastructure Provision

Go to terraform_files

```bash
cd infrastructure/terraform_files/
```

Create SSH server key

```bash
ssh-keygen -m PEM -f server
```

Restrict servers with your Cloud9 SSH connection 

Get the Cloud9 public key

Get public IP : 

```bash
curl http://checkip.amazonaws.com
```

![gras](../../image/provisioning_lab/1.png)

Copy public IP and paste into Security Group terraform file

![gras](../../image/provisioning_lab/3.png)

```
terraform init
```

![gras](../../image/provisioning_lab/4.png)

```
terraform apply --auto-approve | tee output.txt
```

![gras](../../image/provisioning_lab/5.png)


Copy output values


![gras](../../image/provisioning_lab/6.png)

