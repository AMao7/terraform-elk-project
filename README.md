# terraform-elk-project

## Requirement
● To deploy an ELK stack in a Linux system (Complete)

● Have a number of logs appear in Kibana (Complete)
## Secondary goals
* Prepare dashboards in kibana (Complete)
* Set some filtering in logstash (Complete)
* Use graylog instead of kibana (TODO)


#### This terraform code contains:
* VPC
* IG
* Route table
* Security group with rules
* Public subnet
* AMI image 
* User data file (which spins up the EC2 instance with the ansible-playbook repo)



#### The steps I took to make this infrastructure was:
1. Created an EC2 instance and downloaded ansible (this part could have been automated/done better by using packer to create the ami)
![image](https://user-images.githubusercontent.com/58399886/127879631-64557d10-d074-4df5-b79c-7260480870f6.png)

2. Creating the EC2 instance with the ansible ami + appropriate security measures, this included setting up the VPC, the security groups and subnets etc, had a slight issue
![image](https://user-images.githubusercontent.com/58399886/127875337-61d7fcb2-470b-463f-9a9b-a4983de8a95d.png)


3. I then created a user data template (user-data.tpl for ref) to clone the repository containing the ansible playbook for ELK + nginx, this will run as soon as the instance is created
![image](https://user-images.githubusercontent.com/58399886/127875776-07270881-49d7-460a-8a38-f1628abfe260.png)

note: hashed out the playbook to test the clone

#### The steps I took to make provision the EC2 instance was:
## Link to ansible-playbook: https://github.com/AMao7/playbook-ansible

4. Once the EC2 span up, the ansible playbooks provisioned the instance with elk + nginx + config changes, I had to debug a number of issues with the configuration files so this step took a while, I had some issues with filebeat not sending logs to logstash and I had to manually do some steps in order update the playbook. I made the mistake of using the incorrect filebeat config structure. But this is goal number one complete!

5. I used nginx logs as the source of logs for this project and utilised the front page of blog page (no css +js included yet) as the static home page. the log files of nginx are kept in /var/logs/nginx and these logs are saved in access.log (for successful outputs) and error.log (for unsuccessful outputs). 

6. One of the requirements for this project was to have a reasonable amount of logs so one way I thought of doing this was to have a python script to hit the nginx endpoint constantly, but to make the logs more diverse, I added a loop for the incorrect page (localhost/errorr!!!!!!) so I can see them in error.logs and hopefully see them in kibana too! I had another issue here where the script was sending too many logs so I had to lower it to not cause space issues

7. I used the command nohup python3 ping_enpoint.py & to run in background and log any issues in nohup.out

8. Filebeat will monitor this directory for all its logs and will output this to logstash

![image](https://user-images.githubusercontent.com/58399886/127877245-2db35ca8-2750-43e5-a3bb-f23cb0052f31.png)

9. Logstash will then take these logs (parse them!) and then send it to elasticsearch where it can be ready for viewing

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




