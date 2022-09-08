# View Logs in Kibana

<!-- Lab: View Logs in Kibana this demo to be shown here. So Provide instructions here as to how to see logs in Kibana for the first time 
Here we may need to tweak the logs folder that are being captured by filebeats to include normal logs as well
As here we are still not running the WAF.
-->

## Kibana

[Kibana URL](../../labsetup/lab_info.md#kibana)

![kibana](images/kibana.png)

## Setup up Kibana

1) Go to [Kibana URL](../../labsetup/lab_info.md#kibana)

2) Click on Index pattern 

![kibana](images/visualize26.png)

3) Create Index pattern 
4) Type `logstash-*` in Index pattern
5) Next setup 

![kibana](images/kibana-index.png)

6) Time Filter field name `@timestamp`

![kibana](images/kibana-index2.png)

7) Create Index pattern

8) Go to Discover

![kibana](images/kibana-dashboard.png)

9) Open Mail Server

![kibana](images/mailserver-alert.png)