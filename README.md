![](https://github.com/joe-at-cp/checkpoint-iaas-mgmt-ibm-vpc/blob/master/CloudGuard_IaaS.jpg?v=4&s=100)

# Check Point CloudGuard Security Management

## About
This template will deploy a new Check Point security management server into an existing VPC environment. This deployment only requires one interface. See below for the prerequisites of this deployment type.

## Before you begin
If deploying R81.10 image
  - Before logging into the web gui you must login via ssh key set the admin password by running, "set user admin password".
  - Important Security Update - The below software images are vulnerable to CVE-2024-24919. See sk182336 to insatll JHF.

If delpoying R81.20 image
  - Images are deployed with with default admin password of admin
    - set new password by running, "set user admin password"
    - 
## Check Point Resources
- Check Point knowledgebase article for IBM Cloud VPC deployments [SK170400](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk170400&partition=Basic&product=Security).

## Required resources
- VPC
- Management Subnet
- SSH Key

## Installing the software
- Check Point [Full Deployment Guide](https://supportcenter.checkpoint.com/supportcenter/portal?action=portlets.DCFileAction&eventSubmit_doGetdcdetails=&fileid=112069)
- Check Point [R81.10 Gaia Administration Guide](https://sc1.checkpoint.com/documents/R81.10/WebAdminGuides/EN/CP_R81.10_Gaia_AdminGuide/Topics-GAG/Getting_Started.htm?tocpath=_____6)
- Check Point [R81.20 Documentation](https://support.checkpoint.com/results/sk/sk173903)

## Upgrading to a new version
- Refer to version admin  guides under installing software

## Uninstalling the software

1. Go to the **Menu** > **Schematics**.
2. Select your workspace name. 
3. Click **Actions** > **Destroy resources**. All resources in your workspace are deleted.
4. Click **Update**.
5. To delete your workspace, click **Actions** > **Delete workspace**.

## Deployment Parameters
| Deploymenmt Parameter | Description |
|-----------------------|-------------|
| VPC_Region | The region where the VPC, networks, and Check Point VSI will be provisioned. To list the available regions, run  the following command: ```ibmcloud is regions```|
| VPC_Zone   | The zone where the VPC, networks, and Check Point VSI will be provisioned. To list the available zones, run  the following command: ```ibmcloud is zones```|
| VPC_Name  | The VPC where the Check Point VSI will be provisioned. To list the all VPCs, run  the following command: ```ibmcloud is vpcs```|
| Resource_Group | The resource group that will be used when provisioning the Check Point VSI. If left unspecififed, the account's default resource group will be used. command: ```ibmcloud resource groups``` |
| Subnet_ID  | The ID of the subnet where the Check Point  VSI will be provisioned.  To list the available subnets, run  the following command: ```ibmcloud is subnets```|
| CP_Version | Version of Check Point CloudGuard to Deploy |
| SSH_Key       | The pubic SSH Key that will be used when provisioning the Check Point  VSI. To list the available SSH keys, run  the following command: ```ibmcloud is keys``` |
| VNF_Security_Group | Enter a unique name for the security-group to be applied to Check Point interfaces, run the following command to show existing security groups: ```ibmcloud is security-groups```  |


## IBM Cloud Regions and Zones
| Region | Zones |
|--------|-------|
| us-south | us-south-1, us-south-2, us-south-3 |
| us-east  | us-east-1, us-east-2, us-east-3 |
| eu-gb    | eu-gb-1, eu-gb-2, eu-gb-3 |
| eu-de    | eu-de-1, eu-de-2, eu-de-3 |
| eu-es    | eu-es-1, eu-es-2, eu-es-3 |
| jp-tok   | jp-tok-1, jp-tok-2, jp-tok-3 |
| jq-osa   | jq-osa-1, jq-osa-2, jq-osa-3 |
| au-syd   | au-syd-1, au-syd-2, au-syd-3 |
| ca-tor   | ca-tor-1, ca-tor-2, ca-tor-3 |
| br-sao   | br-sao-1, br-sao-2, br-sao-3 |

To list the available regions, run the following command: ```ibmcloud is regions```
 
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

NOTE: <br>
Recommended profile to managing X gateways : (bx2-4x16 = 5GW's), (mx2-4x32 = 10GW's), (mx2-8x64 = 25GW's), (mx2-16x128 = 50GW's) <br>
Please contact Check Point for assistance managing environments with larger than 50GW's <br>
Performance can be limited by the network bandwidth allocated to the profile by IBM Cloud <br>

## About Check Point Software Technologies Ltd.
Check Point Software Technologies Ltd. (www.checkpoint.com) is a leading provider of cyber security solutions to governments and corporate <br> 
enterprises globally. Its solutions protect customers from cyber-attacks with an industry leading catch rate of malware, ransomware and other <br>
types of attacks. Check Point offers a multilevel security architecture that defends enterprises’ cloud, network and mobile device held information, <br>
plus the most comprehensive and intuitive one point of control security management system. Check Point protects over 100,000 organizations of all sizes. <br>
