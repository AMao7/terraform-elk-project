# terraform-elk-project

## Requirement
● To deploy an ELK stack in a Linux system (Complete)

● Have a number of logs appear in Kibana (Complete)
## Secondary goals
* Prepare dashboards in kibana (Complete)
* Set some filtering in logstash (Complete)
* Use graylog instead of kibana (TODO)


#### The terraform code contains:
* VPC
* IG
* Route table
* Security group with rules
* Public subnet
* AMI image 
* User data file (which spins up the EC2 instance with the ansible-playbook repo)

#### The ansible code contains (https://github.com/AMao7/playbook-ansible):
* Java (ELK is dependent on this)
* Elasticsearch
* Logstash
* Kibana
* Filebeat with grok (used to send parsed logs to logstash)
* Nginx (contains the static site)
* a python script that will ping the nginx enpoint for logs


#### The steps I took to make this infrastructure was:
1. Creating an EC2 instance and downloading ansible on that instance (this part could have been automated/done better by using packer to create the ami)
![image](https://user-images.githubusercontent.com/58399886/127879631-64557d10-d074-4df5-b79c-7260480870f6.png)

2. Creating the EC2 instance with the ansible ami + terraform which included the appropriate security measures, this included setting up the VPC, the security groups and subnets etc.
![image](https://user-images.githubusercontent.com/58399886/127875337-61d7fcb2-470b-463f-9a9b-a4983de8a95d.png)


3. I then created a user data template (user_data.tpl for ref) to clone the repository containing the ansible playbook for ELK + nginx, this will run as soon as the instance is created
![image](https://user-images.githubusercontent.com/58399886/127875776-07270881-49d7-460a-8a38-f1628abfe260.png)

note: hashed out the playbook to test the clone

#### The steps I took to provision the EC2 instance was:
## Link to ansible-playbook: https://github.com/AMao7/playbook-ansible

4. Once the EC2 span up, the ansible playbooks provisioned the instance with the ELK stack + nginx + config changes. I then had to debug a number of issues with the configuration files so this step took a while, I had some issues with filebeat not sending logs to logstash and I had to manually do some steps in order update the playbook. I made the mistake of using the incorrect filebeat config structure. But this is goal number one complete!

5. I used nginx logs as the source of logs for this project and utilised a basic html page as the static home page. the log files of nginx are kept in /var/logs/nginx and these logs are saved in access.log (for successful outputs) and error.log (for unsuccessful outputs). 

6. One of the requirements for this project was to have a reasonable amount of logs so one way I thought of doing this was to have a python script to hit the nginx endpoint constantly, but to make the logs more diverse, I added a loop for the incorrect page (localhost/errorr!!!!!!) so I can see them in error.logs and hopefully see them in kibana too! I had another issue here where the script was sending too many logs so I had to lower it to not cause space issues.

7. I used the command nohup python3 ping_enpoint.py & to run in background and log any issues in nohup.out

8. Filebeat will monitor the /var/log/nginx directory for all the nginx logs and will output this to logstash

![image](https://user-images.githubusercontent.com/58399886/127877245-2db35ca8-2750-43e5-a3bb-f23cb0052f31.png)

9. Logstash will then take these logs (parse them!) and then send it to elasticsearch where it can be ready for viewing in kibana

10. A secondary goal of this project was to add a filter to the logstash part of the stack , for this I used grok which is a great parser of unstructured data, it works by matching keywords to each other. Using grok took some time to do until i found something called a grok debugger in kibana
![image](https://user-images.githubusercontent.com/58399886/127878209-41b8da0a-a468-41c5-91ca-7842e73ba8ad.png)

* This tool saved me a lot of time in parsing the nginx logs I was getting, the filters 'response' 'request' and all the others can be used as filters for visualisation now

11. Making Kibana Dashboards! Below is an example of using geoip, http status codes, most visited urls and content in the nginx log path
![image](https://user-images.githubusercontent.com/58399886/127878427-0b9aa42c-74bc-4a9a-bf0d-e5c1ddef6293.png)


#### Things I could have done better + how would I improve this to scale 
1. I could have used puppet + packer to create the ami + provision it with elk
2. I could have used containerisation instead of aws to host this or perhaps set up kubernetes/docker in aws for further isolation
3. I could have created a load balancer + autoscaling group to reduce single point of failure and spread load better (Using one aws ec2 instance for everything is not advisable)
4. Could have set up graylog with elasticsearch (by adding graylog to ansible playbook and configure graylog to speak to elasticsearch)
5. Remove single point of failure, currently I have ELK + nginx running on one ec2 instance, instead I could run them seperately and even in different availability zones.

#### Benefits of the ELK stack
1. Aggregations of logs from different streams of data resources in one central search tool is very convenient for users with complex logging systems
2. Processing – turning logs into meaningful data ready to be visualised
3. Storage/time capabilties – the ability to store data for extended time periods to allow for monitoring and looking at trends
4. Analysis – Being able to ask questions about the data and creating visualisations and dashboards
5. Open source, so new features are regularly added and barrier to use is low


