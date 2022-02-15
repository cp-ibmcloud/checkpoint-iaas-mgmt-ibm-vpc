##############################################################################
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key   = var.ibmcloud_api_key
  generation         = 2
  region             = var.VPC_Region
  ibmcloud_timeout   = 300
  resource_group     = var.Resource_Group
}

##############################################################################
# Variable block - See each variable description
##############################################################################

variable "VPC_Region" {
  default     = ""
  description = "The region where the VPC, networks, and Check Point VSI will be provisioned."
}

variable "Resource_Group" {
  default     = ""
  description = "The resource group that will be used when provisioning the Check Point VSI. If left unspecififed, the account's default resource group will be used."
}

variable "VPC_Name" {
  default     = ""
  description = "The VPC where the Check Point VSI will be provisioned."
}

variable "Subnet_ID" {
  default     = ""
  description = "The ID of the subnet where the Check Point VSI will be provisioned."
}

variable "SSH_Key" {
  default     = ""
  description = "The pubic SSH Key that will be used when provisioning the Check Point  VSI."
}

variable "VNF_Security_Group" {
  default     = ""
  description = "Enter a unique name for the security-group to be applied to Check Point interfaces."
}

variable "VNF_CP-MGMT_Instance" {
  default     = "checkpoint-management-server"
  description = "The name of the Check Point Management Server that will be provisioned."
}

variable "VNF_Profile" {
  default     = "bx2-2x8"
  description = "The VNF profile that defines the CPU and memory resources. This will be used when provisioning the Check Point VSI."
}

variable "CP_Version" {
  default     = "R8110"
  description = "The version of Check Point to deploy. R8110, R81, R8040, R8030"
}

variable "CP_Type" {
  default     = "Management"
  description = "(HIDDEN) Gateway or Management"
}

variable "vnf_license" {
  default     = ""
  description = "(HIDDEN) Optional. The BYOL license key that you want your cp virtual server in a VPC to be used by registration flow during cloud-init."
}

variable "ibmcloud_endpoint" {
  default     = "cloud.ibm.com"
  description = "(HIDDEN) The IBM Cloud environmental variable 'cloud.ibm.com' or 'test.cloud.ibm.com'"
}

variable "delete_custom_image_confirmation" {
  default     = ""
  description = "(HIDDEN) This variable is to get the confirmation from customers that they will delete the custom image manually, post successful installation of VNF instances. Customer should enter 'Yes' to proceed further with the installation."
}

variable "ibmcloud_api_key" {
  default     = ""
  description = "(HIDDEN) Holds the user api key"
}

variable "TF_VERSION" {
 default = "0.12"
 description = "terraform engine version to be used in schematics"
}

##############################################################################
# Data block
##############################################################################

data "ibm_is_subnet" "cp_subnet1" {
  identifier = var.Subnet_ID
}

data "ibm_is_region" "region" {
  name = var.VPC_Region
}

data "ibm_resource_group" "rg" {
  name = var.Resource_Group
}

data "ibm_is_ssh_key" "cp_ssh_pub_key" {
  name = var.SSH_Key
}

data "ibm_is_instance_profile" "vnf_profile" {
  name = var.VNF_Profile
}

data "ibm_is_vpc" "cp_vpc" {
  name = var.VPC_Name
}

##############################################################################
# Create Security Group
##############################################################################

resource "ibm_is_security_group" "ckp_security_group" {
    name = var.VNF_Security_Group
    vpc = data.ibm_is_vpc.cp_vpc.id
    resource_group = data.ibm_resource_group.rg.id
}

#Egress All Ports
resource "ibm_is_security_group_rule" "allow_egress_all" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
}

#Ingress 22 Port
resource "ibm_is_security_group_rule" "allow_22" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

#Ingress 443 Port
resource "ibm_is_security_group_rule" "allow_443" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

#Ingress 18200 Ports
resource "ibm_is_security_group_rule" "allow_18200s" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18209
    port_max = 18211
  }
}

#Ingress 18264 Port
resource "ibm_is_security_group_rule" "allow_18264" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18264
    port_max = 18264
  }
}

#Ingress 18100 Ports
resource "ibm_is_security_group_rule" "allow_18100s" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18190
    port_max = 18191
  }
}

#Ingress 19009 Port
resource "ibm_is_security_group_rule" "allow_19009" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 19009
    port_max = 19009
  }
}

#Ingress 257 Port
resource "ibm_is_security_group_rule" "allow_257" {
  depends_on = [ibm_is_security_group.ckp_security_group]
  group      = ibm_is_security_group.ckp_security_group.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 257
    port_max = 257
  }
}

##############################################################################
# Create Check Point Management Server
##############################################################################

locals {
  image_name = "${var.CP_Version}-${var.CP_Type}"
  image_id = lookup(local.image_map[local.image_name], var.VPC_Region)
}

resource "ibm_is_instance" "cp_mgmt_vsi" {
  depends_on = [ibm_is_security_group_rule.allow_257]
  name    = var.VNF_CP-MGMT_Instance
  image   = local.image_id
  profile = data.ibm_is_instance_profile.vnf_profile.name
  resource_group = data.ibm_resource_group.rg.id

  #eth0 - Management Interface
  primary_network_interface {
    name   = "eth0"
    subnet = data.ibm_is_subnet.cp_subnet1.id
    security_groups = [ibm_is_security_group.ckp_security_group.id]
  }

  vpc  = data.ibm_is_vpc.cp_vpc.id
  zone = data.ibm_is_subnet.cp_subnet1.zone
  keys = [data.ibm_is_ssh_key.cp_ssh_pub_key.id]

  #Custom UserData
  user_data = file("user_data")

  //User can configure timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

#Create and Assoiciate Floating IP Address
resource "ibm_is_floating_ip" "cp_mgmt_vsi_floatingip" {
  name   = "${var.VNF_CP-MGMT_Instance}-fip"
  target = ibm_is_instance.cp_mgmt_vsi.primary_network_interface.0.id
}
