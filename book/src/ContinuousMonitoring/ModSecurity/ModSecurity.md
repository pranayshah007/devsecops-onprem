# Web Application Firewall

## Integrating WAF in DevOps pipeline

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

![staging](CM-1/waf-pipeline.png)

### Application in Production Behind WAF

[Production Behind WAF](../../labsetup/lab_info.md#production-waf)

![staging](CM-1/app.png)

### Perform some attack using malicious input on login page

[Production Behind WAF](../../labsetup/lab_info.md#production-waf)

![403](CM-1/403.png)