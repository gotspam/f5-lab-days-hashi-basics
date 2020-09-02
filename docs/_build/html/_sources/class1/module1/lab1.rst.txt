BIG-IP Infrastructure Onboarding
################################

#. Confirm BIG-IP is not configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore Network SelfIP and Vlan settings are not configured

#. Create main.tf to use terraform bigip provider

   - Open client server vscode termninal
   - ``mkdir ~/projects/lab1a``
   - ``cd ~/projects/lab1a``
   - ``touch main.tf``
   - use vscode to add the following code to **main.tf**

   .. code:: json

     terraform {
     required_providers {
       bigip = {
         source = "F5Networks/bigip"
         version = "1.3.1"
       }
     }
     }

     provider "bigip" {
       address = "10.1.1.6"
       username = "admin"
       password = "F5d3vops$"
     }

     resource "bigip_command" "showversion" {
       commands   = ["show sys version"]
     }

     output "showversion" {
       value = "${bigip_command.showversion.command_result}"
     }

#. Test terraform connectivity to bigip

   - ``terraform  init``

   .. image:: /_static/tinit.png
       :height: 300px

   - ``terraform plan``

   .. image:: /_static/tplan.png
       :height: 300px

   - ``terraform apply``

   .. image:: /_static/tapply.png
       :height: 300px

#. Create f5base.tf to configure base bigip network

   - ``touch f5base.tf``
   - use vscode to add the following code to **f5base.tf**

   .. code:: json
   
      resource "bigip_sys_ntp" "ntp1" {
        description = "/Common/NTP1"
        servers = ["time.google.com"]
        timezone = "America/Los_Angeles"
      }

      resource "bigip_sys_dns" "dns1" {
        description = "/Common/DNS1"
        name_servers = ["8.8.8.8"]
        number_of_dots = 2
        search = ["f5.com"]
      }

      resource "bigip_net_vlan" "vlan1" {
        name = "/Common/internal"
        interfaces {
          vlanport = 1.1
          tagged = false
        }
      }

      resource "bigip_net_vlan" "vlan2" {
        name = "/Common/external"
        interfaces {
          vlanport = 1.2
          tagged = false
        }
      }

      resource "bigip_net_selfip" "selfip1" {
         name = "/Common/internalselfIP"
         ip = "10.1.10.6/24"
         vlan = "/Common/internal"
         depends_on = [bigip_net_vlan.vlan1]
      }

      resource "bigip_net_selfip" "selfip2" {
         name = "/Common/externalselfIP"
         ip = "10.1.20.6/24"
         vlan = "/Common/external"
         depends_on = [bigip_net_vlan.vlan2]
      }

   - ``terraform plan``
   - ``terraform apply``

#. Confirm BIG-IP is now configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore Network -> SelfIP and Vlan settings are now configured

   .. image:: /_static/selfip.png
       :height: 150px

   .. image:: /_static/vlan.png
       :height: 150px