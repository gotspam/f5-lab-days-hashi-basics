Deploy App Services via AS3
###########################

In this section you will create a json declaration to deploy app services using AS3.


#. Confirm BIG-IP is not configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to validate no app services

#. Create **main.tf** to use terraform bigip provider

   - Open client server **vscode termninal**
   - ``mkdir ~/projects/lab2``
   - ``cd ~/projects/lab2``
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

      resource "bigip_as3"  "tenant01_app1" {
         as3_json = "${file("app1.json")}"
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

#. Create **app1.json**

   - ``touch app1.json``
   - use vscode to add the following code to **app1.json**

   .. code:: json

      {
          "class": "AS3",
          "action": "deploy",
          "persist": true,
          "declaration": {
              "class": "ADC",
              "schemaVersion": "3.0.0",
              "id": "example-01",
              "label": "Tenant 1",
              "remark": "Simple HTTP application with round robin pool",
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
              "tenant_01": {
                  "class": "Tenant",
                  "App_1": {
                      "class": "Application",
                      "template": "generic",
                  "app1_vs": {
                      "class": "Service_Generic",
                      "virtualAddresses": [
                          {"use": "/Common/Shared/virt_addr_10_1_20_20"}
                      ],
                      "virtualPort": 3000,
                      "pool": "web3000_pool",
                      "profileHTTP": {"use": "http"}
                      },
                      "web3000_pool": {
                          "class": "Pool",
                          "monitors": [
                              "http"
                          ],
                          "members": [
                              {
                                  "shareNodes": true,
                                  "servicePort": 3000,
                                  "serverAddresses": [
                                      "10.1.10.5",
                                      "10.1.10.10"
                                  ]
                              }
                          ]
                      }
                  }
              }
          }
      }

#. Deploy App1 services

   - ``terraform  init``
   - ``terraform plan``
   - ``terraform apply -auto-approve``

   .. image:: /_static/l2init.png
       :height: 300px

#. Confirm BIG-IP is now configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to view app1 services

   .. image:: /_static/tenant1.png
       :height: 300px

#. Create app1a.json

   - ``touch app1a.json``
   - use vscode to add the following code to **app1a.json**

   .. code:: json

      {
          "class": "AS3",
          "action": "deploy",
          "persist": true,
          "declaration": {
              "class": "ADC",
              "schemaVersion": "3.0.0",
              "id": "example-01",
              "label": "Tenant 1",
              "remark": "Simple HTTP application with round robin pool",
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
              "tenant_01": {
                  "class": "Tenant",
                  "App_1": {
                      "class": "Application",
                      "template": "generic",
                  "app1_vs": {
                      "class": "Service_Generic",
                      "virtualAddresses": [
                          {"use": "/Common/Shared/virt_addr_10_1_20_20"}
                      ],
                      "virtualPort": 3000,
                      "pool": "web3000_pool",
                      "profileHTTP": {"use": "http"}
                      },
                      "web3000_pool": {
                          "class": "Pool",
                          "monitors": [
                              "http"
                          ],
                          "members": [
                              {
                                  "shareNodes": true,
                                  "servicePort": 3000,
                                  "serverAddresses": [
                                      "10.1.10.5",
                                      "10.1.10.10"
                                  ]
                              }
                          ]
                      }
                  },
        "App_2": {
          "class": "Application",
          "template": "http",
          "serviceMain": {
          "class": "Service_HTTP",
                "virtualAddresses": [
                    {"use": "/Common/Shared/virt_addr_10_1_20_20"}
                ],
                "virtualPort": 8080,
                "pool": "web8080_pool",
                "persistenceMethods": []
          },
          "web8080_pool": {
          "class": "Pool",
          "monitors": [
            "http"
          ],
          "members": [{
                  "shareNodes":true,
            "servicePort": 8080,
            "serverAddresses": [
            "10.1.10.5",
            "10.1.10.10"
            ]
          }]
          }
        }
      }
      }
      }

#. Modify **main.tf** to use **app1a.json**

   - use vscode to replace **app1.json** with **app1a.json**

   .. code:: json

      resource "bigip_as3"  "tenant01_app1" {
         as3_json = "${file("app1a.json")}"
      }

#. Redeploy App1 services with 2nd app

   - ``terraform plan``
   - ``terraform apply -auto-approve``

#. Confirm BIG-IP is now configured with multiple apps

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to view **app1** and **app2** services

   .. image:: /_static/tenant1a.png
       :height: 300px

   .. TIP:: 
      Creating multiple versions of your as3 json files allows for quick rollback to previous version if issues occur.
