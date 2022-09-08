# Jenkins Setup

## Setup Jenkins Credentials

Login into jenkins server 

Go to Credentials 

1.	Enter the credentials “jenkins:jenkins” and proceed to ‘Sign In’

[Jenkins URL](../labsetup/lab_info.md#jenkins)

![pic_1](images/52.png) 

2.	On successful login you would be able to see the dashboard. Click on “Credentials” . 

![pic_1](images/53.png) 

Note - if jenkins credentials is not available in the left hand menu, Please locate as shown below :

![pic_1](images/101.png)

3.	We have already added 5 different set of credentials that will be required for our pipeline build process as shown below :

![pic_1](images/102.png) 


*Note - We only need to modify git credentials and mysqlvault credentials, rest all credentials will remain as it is.

Lets now first modify our git credentials using below instructions :

### Github SSH setup in Jenkins

1. Click on Jenkins in Stores from parent section as shown below in image :

![pic_1](images/103.png) 

2. Click on Global credentials as shown below :

![pic_1](images/104.png) 

3. We need to modify git credentials hence click on git id as shown below :

![pic_1](images/105.png) 

4. Next click on update option from left hand menu as shown :

![pic_1](images/106.png) 

5. Next add your own github account username under "Username" field as shown :

![pic_1](images/107.png) 
 
6. Copy you private SSH key from SSH folder in IDE using below command and paste it under Private key option as shown :

```bash
cat /root/.ssh/id_rsa
```
![pic_1](images/88.png)

### Vault Token setup in Jenkins

1. Click on back to global credentials as shown :

![pic_1](images/108.png) 

2. Select mysqlvault ID under global credentials as shown :

![pic_1](images/109.png) 

3. Next click on update option from left hand menu as shown :

![pic_1](images/110.png) 

4. Now under secret click on change password and add your vault token and click save.

Now confirm that you can see 5 different set of credentials added to jenkins

![pic_1](images/89.png)

### ArhcerySec Credentials Setup (For on-prem-lab Only)

1.	Open your browser and open ArcherySec Application. 

![pic_1](images/99.png)

2.	Click on the Sign Up button and enter the credentials as shown below. 

![pic_1](images/100.png)

## Create your first DevSecOps Pipeline

1.	Open your browser and Login to Jenkins using the credentials 

`jenkins:jenkins`

![pic_1](images/71.png)

2.	Click on “Create new jobs” to create a new job.

![pic_1](images/72.png)

3.	Next enter some name (eg. ‘devops’ ) in the “Enter an item name” section.
Click “Pipeline” and then click “OK” at the bottom.

![pic_1](images/73.png)

4.	Enter the Configuration details as specified below.

![pic_1](images/74.png)

Poll SCM : * * * * *

![pic_1](images/75.png)

Copy your git Repo ssh URL and provide into Jenkins

![pic_1](images/76.png)

Ensure to uncheck the lightweight checkout option or else the changes in source code will not be visible

![pic_1](images/111.png)

5.	Once the configuration is saved, a build will run.

![pic_1](images/77.png)

6.	Click to open “Blue Ocean”. 

![pic_1](images/78.png)

7.	Below is the progress as represented by Blue Ocean plugin. 

![pic_1](images/79.png)

![pic_1](images/80.png)

![pic_1](images/81.png)

By the end of the ‘Staging Deploy’ stage your staging application should be up and running as shown below

[Staging URL](../labsetup/lab_info.md#staging)

![pic_1](images/82.png)

Click On the ‘Production Deploy Approval’

Click OK to deploy

![pic_1](images/84.png)

After approving the deployment our pipeline would be complete as shown below

![pic_1](images/85.png)

Once the pipeline is complete please access the production application deployed as shown below 

[Production URL](../labsetup/lab_info.md#production)

![pic_1](images/86.png)

