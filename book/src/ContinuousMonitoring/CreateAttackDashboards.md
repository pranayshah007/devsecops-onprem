# Create Attack Dashboards in Kibana

<!-- Lab: Create Attack Dashboards -->

First from left hand menu select Visualize and then click on Create New Visualization

![kibana](images/visualize1.png)

Under New Visualization, Select Data Table

![kibana](images/visualize2.png)

Next select source as "logstash-*"

![kibana](images/visualize2.1.png)

Next under buckets menu click on Add

![kibana](images/visualize3.png)

Next select option Split rows under add bucket

![kibana](images/visualize4.png)

Next under "Select an aggregation" select "Terms"

![kibana](images/visualize5.png)

Under field drop down menu select "client.keyword" as filter

![kibana](images/visualize6.png)

Now that we have created our filters, lets name the label as "IP"

![kibana](images/visualize7.png)

Now click on Update to see information related to different IP address which are generating attack logs against our application

![kibana](images/visualize8.png)

Lets add another sub bucket to view different attack names by selecting option "split rows"

![kibana](images/visualize9.png)

Under select aggregation option from drop down select "Terms"

![kibana](images/visualize10.png)

Now under field filter select "attack_name.keyword"

![kibana](images/visualize11.png)

Add name of custom label as "Attacks" and then click on update to view different attack information as shown below :

![kibana](images/visualize12.png)

Save the visualization by clicking save button

![kibana](images/visualize13.png)

Now we can see our first visualization that we created

![kibana](images/visualize14.png)

Now lets add a pie chart visualization to help analyze logs better

Select New Visualization and select pie as filter

![kibana](images/visualize15.png)

Under buckets option select Split slices

![kibana](images/visualize16.png)

Next select aggregation as "Terms", Field as "attack_name.keyword", order by as "Metric: Count" and order as "Descending"

![kibana](images/visualize17.png)

Next click on update and now you can see pie chart daigram of different attacks

![kibana](images/visualize18.png)

Now lets create a new dashboard to see data from both the visualization's created

From left hand menu select "Dashboard"

![kibana](images/visualize19.png)

Next select create dashboard

![kibana](images/visualize20.png)

Next under filters click "Add an existing"

![kibana](images/visualize21.png)

Under Add panels select both our visualizations

![kibana](images/visualize22.png)

Now we can see attacks logs both as pie chart and data table

![kibana](images/visualize23.png)

Save the dashboard and this can now be used to view real time attack logs

![kibana](images/visualize24.png)

![kibana](images/visualize25.png)