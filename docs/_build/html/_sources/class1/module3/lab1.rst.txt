Deploy AS3 WAF Policy
#####################

#. Confirm BIG-IP is not configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to validate tenant_02 app services does not exist

#. Create **main.tf** to use terraform bigip provider

   - Open client server **vscode termninal**
   - ``mkdir ~/projects/lab3``
   - ``cd ~/projects/lab3``
   - ``touch main.tf``
   - use vscode to add the following code to **main.tf**

   .. code:: json

      terraform {
        required_providers {
          bigip = {
            source = "F5Networks/bigip"
          }
        }
      }

      provider "bigip" {
          address = var.address
          username = var.username
          password = var.password
      }

      resource "bigip_as3"  "tenant02_app3" {
         as3_json = "${file("app3.json")}"
      }

#. Create **variables.tf**

   - ``touch variables.tf``
   - use vscode to add the following code to **variables.tf**

   .. code:: json

      variable "address" {}
      variable "username" {}
      variable "password" {}

#. Create **terraform.tfvars**

   - ``touch terraform.tfvars``
   - use vscode to add the following code to **terraform.tfvars**

   .. code:: json

      address = "10.1.1.6"
      username = "admin"
      password = "F5d3vops$"

#. Create **app3.json**

   - ``touch app3.json``
   - use vscode to add the following code to **app3.json**

   .. code:: json

      {
         "class": "AS3",
         "action": "deploy",
         "persist": true,
         "declaration": {
            "class": "ADC",
            "schemaVersion": "3.0.0",
            "id": "tenant2",
            "label": "Sample 4",
            "remark": "HTTPS with sslbridging and external WAF",
            "Common": {
               "class": "Tenant",
               "Shared": {
                   "class": "Application",
                   "template": "shared",
                   "virt_addr_10_1_20_20": {
                       "class": "Service_Address",
                       "virtualAddress": "10.1.20.20"
                   }
               }
           },
            "tenant_02": {
            "class": "Tenant",
            "App_3": {
                  "class": "Application",
                  "template": "generic",
                  "app3_vs": {
                  "class": "Service_HTTPS",
                  "virtualAddresses": [
                     {"use": "/Common/Shared/virt_addr_10_1_20_20"}
                 ],
                  "pool": "web_pool",
                  "policyWAF": {"use": "My_AWAF_Policy"},
                  "serverTLS": "webtls"
                  },
                  "web_pool": {
                  "class": "Pool",
                  "loadBalancingMode": "predictive-node",
                  "monitors": [
                  "http"
                  ],
                  "members": [{
                     "shareNodes": true,
                     "servicePort": 3000,
                     "serverAddresses": [
                     "10.1.10.5"
                     ]
                  }]
                  },
                  "webtls": {
                  "class": "TLS_Server",
                  "certificates": [{
                     "certificate": "webcert"
                  }]
                  },
                  "webcert": {
                  "class": "Certificate",
                  "remark": "using default",
                  "certificate": {"bigip":"/Common/default.crt"},
                  "privateKey": {"bigip":"/Common/default.key"}
                  },
                  "My_AWAF_Policy": {
                     "class": "WAF_Policy",
                     "ignoreChanges": false,
                     "url": "https://raw.githubusercontent.com/scshitole/more-terraform/master/Sample_app_sec_02_waf_policy.xml"
                  }
              }
            }
         }
      }

#. Deploy Tenant02 App3 services

   - ``terraform  init``
   - ``terraform plan``
   - ``terraform apply -auto-approve``

#. Confirm BIG-IP is now configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore Local **Traffic -> Network Map** to view tenant02 app3 services

   .. image:: /_static/app3nmap.png
       :height: 300px

   - Click **app3_vs** to view details of **tenant02 app3** services and note a WAF Policy associated

   .. image:: /_static/app3detail.png
       :height: 300px
