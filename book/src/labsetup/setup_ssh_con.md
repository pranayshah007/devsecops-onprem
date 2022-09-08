# Setup SSH connection

## IDE URL

[IDE URL](../labsetup/lab_info.md#ide)

### SSH Key gen

Ensure that you are under code folder, if not then use the below command to change directory :

```bash
cd  code
```

Type below command and generate ssh key

```bash
ssh-keygen
```

> Note : Do not add passphrase to the public key generated and leave it as blank


![gras](ssh-key/img-9.png)

### Copy ssh Public Key

```bash
cat /root/.ssh/id_rsa.pub
```

![gras](ssh-key/img-10.png)

- Go to Github setting page.
- Select SSH and PGP key
- Create New SSH Key

![gras](ssh-key/img-11.png)

- Add a new Title to SSH Key
- Upload SSH public key

![gras](ssh-key/img-12.png)

## Create New Repository in GitHub

- Go to your Github account
- Create new repository 
- Name as devsecops-lab
- Select as Private repository

![gras](ssh-key/img-13.png)

## Pushing our code to github.com

- First we need create a blank git repository using the command below
```bash
git init
```

- Now we need to stage our changes using the commands below
```bash
git add .
```
- Next we need to configure our email and name using the commands below
```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

- Let's commit our changes
```bash
git commit -m "first commit"
``` 

- Now select the branch using command below
```bash
git branch -M master
```

- lets now add our remote repository (please do not copy paste the below command as is)
```bash
git remote add origin "(Add your Repo URL here)"
```


- Finally, lets push our changes to our github.com repository
```bash
git push -u origin master
```




