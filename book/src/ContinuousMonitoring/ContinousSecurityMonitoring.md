# Continous Security Monitoring

<!-- Describe in brief about ModSecurity and ElastAlert with their configurations and references in ansible-->

![img](images/csm.png)

<!-- Lab: Viewing Attack Logs in Kibana Detail steps for this too here -->

1. Copy Contents of `Jenkinsfile.WAF`

2. Paste the Contents into `Jenkinsfile` and Commit the code.

3. Fire the below Git Commands to execute the Pipeline

```bash
git add .
```

```bash
git commit -am "WAF"

```

```bash
git push
```

![staging](images/waf-pipeline.png)

### Application in Production Behind WAF

[Production Behind WAF](../../labsetup/lab_info.md#production-waf)

![staging](images/app.png)

### Perform some attack using malicious input on login page

[Production Behind WAF](../../labsetup/lab_info.md#production-waf)

![403](images/403.png)