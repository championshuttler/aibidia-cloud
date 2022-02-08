# Aibidia Assignment

## Task #1:Draw application architecture on high level for your sales department ##

Our architecture will have the componennts. 

* GCP - Using GCP for cloud infra

* NAT gateway 

* VPC - Pool of networked cloud resources.

* Internet gateway - it enables inbound and outbound traffic from the internet to the VPC. it can transfer communications between an enterprise network and the Internet.

* Public Route table - Rules to help in directing the traffic

* Public Subnet - Public subnet is getting used to show the info outside our cloud.

* Private Subnet - helps in accessing internally by other resources within your cloud container.

* GCP Instance
First one must SSH into the gcp instance. To do this, one must:
1.	Create a key pair from the gcp console 
2.	Download the keypair 
3.	ssh -i keypair.pem 

* virtual firewall to secure the infra.
  
* Google storage to store the information.

*	RDS for storing the data.


## Task 2: Deployment automation

We can create cron or automatic runnable job triggered by customers, which will setup all enviroment for the customer which is easily done by using terraform templates which will setup gcp infra using our terraform script and setting up the infra. 

I would develop a auto-setup/auto-run file that, upon being executed by a customer in their device, it would detect the OS, storage requirements and specifications of the system before configuring the settings the app will use for maximum efficacy of execution.

### Would your architecture change because of a number of customers? 

Yes it will change and autoscale using load balancer and Autoscaling groups of instances in gcp so if traffic increases with further adoption of the software it will help us in scalingn the infra when we need it and it will make sure that we are not exhausting the cost when the traffic is low. Also load balancer will help us in routing the traffic to the servers in a good manner and divert the traffic accordingly.  

Yes, most certainly. Now I would need to as mentioned above devise a auto-run for customers that do not know the manual installation and which settings to run the application on. 

Since the load on the application is heavy, to easy it, I will add another ec2 instance. This will no contain a autoscaling group. An autoscaling group contains a collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management. What this means is that, if traffic will increase later on, the autoscaling will detect this and add an extra ec2 instance. This enables resources to scale up only when needed and scale down when traffic subsides. 

If something goes wrong we will have a team of support engineers to help customers in case something goes unexpected. We will make a open bug tracking platform for customers.