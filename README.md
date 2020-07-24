<p align="center">
  <img width="460" src="http://blog.checkpoint.com/wp-content/uploads/2018/02/CloudGuard_IaaS.jpg">
</p>

# Check Point CloudGuard Security Management

## Deployment Parameters
| Deploymenmt Parameter | Description |
|-----------------------|-------------|
| region    | Geographical IBM Cloud VPC location to deploy CloudGuard. CloudGuard is supported for deployment in all VPC Gen2 regions. See below for a list of regions and zones|
| zone      | Availability zone inside selected region|
| vpc_name  | Name of VPC to deploy into|
| resource_group | Name of VPC resource group to deploy into |
| subnet_id1 | ID (not the name) of the subnet for eth0)
| ssh_key_name       | Name of the ssh key to apply to the CloudGuard instance |
| vnf_security_group | Name of the security group to apply to the CloudGuard instance |




## IBM Cloud Regions and Zones
| Region | Zones |
|--------|-------|
| us-south | us-south-1, us-south-2, us-south-1 |
| us-east  | us-east-1, us-east-2, us-east-1 |
| eu-gb    | eu-gb-1, eu-gb-2, eu-gb-3 |
| eu-de    | eu-de-1, eu-de-2, eu-de-3 |
| jp-tok   | jp-tok-1, jp-tok-2, jp-tok-3 |
 
## IBM Cloud VPC Deployment Profiles
| Profile   | Archetecture | Family     | vCPUs | Memory (GB) | Network Performance (Gbps)|       
|-----------|--------------|------------|-------|-------------|---------------------------|
|bx2-2x8    |     amd64    |   balanced |  2    |   8         |  4   |
|bx2-4x16   |     amd64    |   balanced |  4    |   16        |  8   |
|bx2-8x32   |     amd64    |   balanced |  8    |   32        |  16  |
|bx2-16x64  |     amd64    |   balanced |  16   |   64        |  32  | 
|bx2-32x128 |     amd64    |   balanced |  32   |   128       |  64  |
|bx2-48x192 |     amd64    |   balanced |  48   |   192       |  80  |
|cx2-2x4    |     amd64    |   compute  |  2    |   4         |  4   |
|cx2-4x8    |     amd64    |   compute  |  4    |   8         |  8   | 
|cx2-8x16   |     amd64    |   compute  |  8    |   16        |  16  | 
|cx2-16x32  |     amd64    |   compute  |  16   |   32        |  32  |
|cx2-32x64  |     amd64    |   compute  |  32   |   64        |  64  | 
|mx2-2x16   |     amd64    |   memory   |  2    |   16        |  4   |   
|mx2-4x32   |     amd64    |   memory   |  4    |   32        |  8   |
|mx2-8x64   |     amd64    |   memory   |  8    |   64        |  16  |  
|mx2-16x128 |     amd64    |   memory   |  16   |   128       |  32  |  
|mx2-32x256 |     amd64    |   memory   |  32   |   256       |  64  |  

NOTE:
Recommended profile to managing X gateways : (bx2-4x16 = 5GW's), (mx2-4x32 = 10GW's), (mx2-8x64 = 25GW's), (mx2-16x128 = 50GW's)
Please contact Check Point for assistance managing environments with larger than 50GW's
Performance can be limited by the network bandwidth allocated to the profile by IBM Cloud


## Check Point Knowledgebase
Click [HERE](https://checkpoint.com/) to view the knowledgebase article for IBM Cloud VPC deployments on the Check Point Usercenter.


## About Check Point Software Technologies Ltd.
Check Point Software Technologies Ltd. (www.checkpoint.com) is a leading provider of cyber security solutions to governments and corporate <br> 
enterprises globally. Its solutions protect customers from cyber-attacks with an industry leading catch rate of malware, ransomware and other <br>
types of attacks. Check Point offers a multilevel security architecture that defends enterprises’ cloud, network and mobile device held information, <br>
plus the most comprehensive and intuitive one point of control security management system. Check Point protects over 100,000 organizations of all sizes. <br>
