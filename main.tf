##############################################################################
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key   = "${var.ibmcloud_api_key}"
  generation         = 2
  region             = "${var.region}"
  ibmcloud_timeout   = 300
  resource_group     = "${var.resource_group}"
}

##############################################################################
# Variable block - See each variable description
##############################################################################

variable "region" {
  default     = "us-east"
  description = "The VPC Region that you want your VPC, networks and the CP virtual server to be provisioned in. To list available regions, run `ibmcloud is regions`."
}

variable "zone" {
  default     = "us-east-3"
  description = "The VPC Zone that you want your VPC networks and virtual servers to be provisioned in. To list available zones, run `ibmcloud is zones`."
}

variable "resource_group" {
  default     = "cprg"
  description = "The resource group to use. If unspecified, the account's default resource group is used."
}

variable "vpc_name" {
  default     = "cpvpc"
  description = "The name of your VPC where Checkpoint GW and Mgmt VSIs are to be provisioned."
}

variable "subnet_id1" {
  default     = "0777-06f95dd6-47e1-4a68-a2e5-24bb8aaee362"
  description = "The id of the subnet where Checkpoint Mgmt VSI to be provisioned."
}

variable "ssh_key_name" {
  default     = "development"
  description = "The name of the public SSH key to be used when provisining Checkpoint GW and Mgmt VSIs."
}

variable "vnf_security_group" {
  default     = "checkpointsg1"
  description = "The security group for VNF VPC"
}

variable "vnf_mgmt_instance_name" {
  default     = "checkpoint-management-server"
  description = "The name of your Checkpoint Mgmt Virtual Server to be provisioned."
}

variable "vnf_profile" {
  default     = "bx2-2x8"
  description = "The profile of compute cpu and memory resources to be used when provisioning cp-GW VSI. To list available profiles, run `ibmcloud is instance-profiles`."
}

variable "vnf_vpc_mgmt_image_name" {
  default     = "checkpoint-mgmt-image1"
  description = "(HIDDEN) The name of the Checkpoint Mgmt custom image to be provisioned in your IBM Cloud account."
}

variable "vnf_cos_mgmt_image_url" {
  default     = "cos://us-east/r80.40-03252020/Check_Point_R80.40_Cloudguard_Security_Management_Generic_06012020_EA.qcow2"
  description = "(HIDDEN) The COS image object SQL URL for Checkpoint Mgmt qcow2 image."
}

variable "vnf_cos_mgmt_image_url_test" {
  default     = ""
  description = "(HIDDEN) The COS image object url for Checkpoint Mgmt qcow2 image in test.cloud.ibm.com."
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


##############################################################################
# Data block 
##############################################################################

data "ibm_is_subnet" "cp_subnet1" {
  identifier = "${var.subnet_id1}"
}

data "ibm_is_region" "region" {
  name = "${var.region}"
}

data "ibm_is_zone" "zone" {
  name   = "${var.zone}"
  region = "${data.ibm_is_region.region.name}"
}

data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}


##############################################################################
# Create Custom Image
##############################################################################

locals {
  image_url_mgmt    = "${var.ibmcloud_endpoint == "cloud.ibm.com" ? var.vnf_cos_mgmt_image_url : var.vnf_cos_mgmt_image_url_test}"
}

resource "ibm_is_image" "cp_mgmt_custom_image" {
  href             = "${local.image_url_mgmt}"
  name             = "${var.vnf_vpc_mgmt_image_name}"
  operating_system = "centos-7-amd64"
  resource_group   = "${data.ibm_resource_group.rg.id}"

  timeouts {
    create = "30m"
    delete = "10m"
  }
}

data "ibm_is_image" "cp_mgmt_custom_image" {
  name = "${ibm_is_image.cp_mgmt_custom_image.name}"
}

data "ibm_is_ssh_key" "cp_ssh_pub_key" {
  name = "${var.ssh_key_name}"
}

data "ibm_is_instance_profile" "vnf_profile" {
  name = "${var.vnf_profile}"
}

data "ibm_is_vpc" "cp_vpc" {
  name = "${var.vpc_name}"
}

##############################################################################
# Create Security Group
##############################################################################

resource "ibm_is_security_group" "ckp_security_group" {
    name = "${var.vnf_security_group}"
    vpc = "${data.ibm_is_vpc.cp_vpc.id}"
    resource_group = "${data.ibm_resource_group.rg.id}"
}

#Egress All Ports
resource "ibm_is_security_group_rule" "allow_egress_all" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "outbound"
  remote     = "0.0.0.0/0"
}

#Ingress 22 Port
resource "ibm_is_security_group_rule" "allow_22" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

#Ingress 443 Port
resource "ibm_is_security_group_rule" "allow_443" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

#Ingress 18200 Ports
resource "ibm_is_security_group_rule" "allow_18200s" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18209
    port_max = 18211
  }
}

#Ingress 18264 Port
resource "ibm_is_security_group_rule" "allow_18264" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18264
    port_max = 18264
  }
}

#Ingress 18100 Ports
resource "ibm_is_security_group_rule" "allow_18100s" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 18190
    port_max = 18191
  }
}

#Ingress 19009 Port
resource "ibm_is_security_group_rule" "allow_19009" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
  direction  = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 19009
    port_max = 19009
  }
}

#Ingress 257 Port
resource "ibm_is_security_group_rule" "allow_257" {
  depends_on = ["ibm_is_security_group.ckp_security_group"]
  group      = "${ibm_is_security_group.ckp_security_group.id}"
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

resource "ibm_is_instance" "cp_mgmt_vsi" {
  depends_on = ["ibm_is_security_group_rule.allow_257", "data.ibm_is_image.cp_mgmt_custom_image"]
  name    = "${var.vnf_mgmt_instance_name}"
  image   = "${data.ibm_is_image.cp_mgmt_custom_image.id}"
  profile = "${data.ibm_is_instance_profile.vnf_profile.name}"
  resource_group = "${data.ibm_resource_group.rg.id}"

  primary_network_interface {
    subnet = "${data.ibm_is_subnet.cp_subnet1.id}"
    security_groups = ["${ibm_is_security_group.ckp_security_group.id}"]
  }
  
  vpc  = "${data.ibm_is_vpc.cp_vpc.id}"
  zone = "${data.ibm_is_zone.zone.name}"
  keys = ["${data.ibm_is_ssh_key.cp_ssh_pub_key.id}"]

  //User can configure timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }
  # Hack to handle some race condition; will remove it once have root caused the issues.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

#Create and Assoiciate Floating IP Address
resource "ibm_is_floating_ip" "cp_mgmt_vsi_floatingip" {
  name   = "${var.vnf_mgmt_instance_name}-fip"
  target = "${ibm_is_instance.cp_mgmt_vsi.primary_network_interface.0.id}"
}

# Delete checkpoint management custom image from the local user after VSI creation.
data "external" "delete_custom_image2" {
  depends_on = ["ibm_is_instance.cp_mgmt_vsi"]
  program    = ["bash", "${path.module}/scripts/delete_custom_image.sh"]

  query = {
    custom_image_id   = "${data.ibm_is_image.cp_mgmt_custom_image.id}"
    region            = "${var.region}"
  }
}

output "delete_custom_image2" {
  value = "${lookup(data.external.delete_custom_image2.result, "custom_image_id")}"
}
