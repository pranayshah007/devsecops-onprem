# Monitoring and Logging 

## Kibana

[Kibana URL](../../labsetup/lab_info.md#kibana)

![kibana](Monitoring_Alerting-1/kibana.png)

## Setup up Kibana

1) Go to [Kibana URL](../../labsetup/lab_info.md#kibana)

2) Click on Index pattern 
3) Create Index pattern 
4) Type `logstash-*` in Index pattern
5) Next setup 

![kibana](Monitoring_Alerting-1/kibana-index.png)

6) Time Filter field name `@timestamp`

![kibana](Monitoring_Alerting-1/kibana-index2.png)

7) Create Index pattern

8) Go to Discover

![kibana](Monitoring_Alerting-1/kibana-dashboard.png)

9) Open Mail Server

![kibana](Monitoring_Alerting-1/mailserver-alert.png)

## Lets now Setup Attack Visualize

First from left hand menu select Visualize and then click on Create New Visualization

![kibana](Monitoring_Alerting-1/visualize1.png)

Under New Visualization, Select Data Table

![kibana](Monitoring_Alerting-1/visualize2.png)

Next select source as "logstash-*"

![kibana](Monitoring_Alerting-1/visualize2.1.png)

Next under buckets menu click on Add

![kibana](Monitoring_Alerting-1/visualize3.png)

Next select option Split rows under add bucket

![kibana](Monitoring_Alerting-1/visualize4.png)

Next under "Select an aggregation" select "Terms"

![kibana](Monitoring_Alerting-1/visualize5.png)

Under field drop down menu select "client.keyword" as filter

![kibana](Monitoring_Alerting-1/visualize6.png)

Now that we have created our filters, lets name the label as "IP"

![kibana](Monitoring_Alerting-1/visualize7.png)

Now click on Update to see information related to different IP address which are generating attack logs against our application

![kibana](Monitoring_Alerting-1/visualize8.png)

Lets add another sub bucket to view different attack names by selecting option "split rows"

![kibana](Monitoring_Alerting-1/visualize9.png)

Under select aggregation option from drop down select "Terms"

![kibana](Monitoring_Alerting-1/visualize10.png)

Now under field filter select "attack_name.keyword"

![kibana](Monitoring_Alerting-1/visualize11.png)

Add name of custom label as "Attacks" and then click on update to view different attack information as shown below :

![kibana](Monitoring_Alerting-1/visualize12.png)

Save the visualization by clicking save button

![kibana](Monitoring_Alerting-1/visualize13.png)

Now we can see our first visualization that we created

![kibana](Monitoring_Alerting-1/visualize14.png)

Now lets add a pie chart visualization to help analyze logs better

Select New Visualization and select pie as filter

![kibana](Monitoring_Alerting-1/visualize15.png)

Under buckets option select Split slices

![kibana](Monitoring_Alerting-1/visualize16.png)

Next select aggregation as "Terms", Field as "attack_name.keyword", order by as "Metric: Count" and order as "Descending"

![kibana](Monitoring_Alerting-1/visualize17.png)

Next click on update and now you can see pie chart daigram of different attacks

![kibana](Monitoring_Alerting-1/visualize18.png)

Now lets create a new dashboard to see data from both the visualization's created

From left hand menu select "Dashboard"

![kibana](Monitoring_Alerting-1/visualize19.png)

Next select create dashboard

![kibana](Monitoring_Alerting-1/visualize20.png)

Next under filters click "Add an existing"

![kibana](Monitoring_Alerting-1/visualize21.png)

Under Add panels select both our visualizations

![kibana](Monitoring_Alerting-1/visualize22.png)

Now we can see attacks logs both as pie chart and data table

![kibana](Monitoring_Alerting-1/visualize23.png)

Save the dashboard and this can now be used to view real time attack logs

![kibana](Monitoring_Alerting-1/visualize24.png)

![kibana](Monitoring_Alerting-1/visualize25.png)