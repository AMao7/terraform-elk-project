# terraform-elk-project

## Requirement
● To deploy an ELK stack in a Linux system (Complete)
● Have a number of logs appear in Kibana (Complete)
## Secondary goals
* Prepare dashboards in kibana (Complete)
* Set some filtering in logstash (Complete)
* Use graylog instead of kibana (TODO)

#### This terraform code contains
* VPC
* IG
* Route table
* Security group with rules
* Public subnet
* AMI image 
* User data file (which spins up the EC2 instance with the ansible-playbook repo)


#### The steps I took to make this infrastructure was
1. Created an EC2 instance and downloaded ansible (this part could have been automated/done better by using packer to create the ami)
2. Creating the EC2 instance with the ansible ami + appropriate security measures, this included setting up the VPC, the security groups and subnets etc, had a slight issue
![image](https://user-images.githubusercontent.com/58399886/127875337-61d7fcb2-470b-463f-9a9b-a4983de8a95d.png)


3. I then created a user data template (user-data.tpl for ref) to clone the repository containing the ansible playbook for ELK + nginx, this will run as soon as the instance is created
![image](https://user-images.githubusercontent.com/58399886/127875776-07270881-49d7-460a-8a38-f1628abfe260.png)
note: hashed out the playbook to test the clone

4. Once the EC2 span up, the ansible playbooks provisioned the instance with elk + config changes, I had to debug a number of issues with the configuration files so this step took a while, I had some issues with filebeat not sending logs to logstash and I had to manually do some steps in order update the playbook. I made the mistake of 
