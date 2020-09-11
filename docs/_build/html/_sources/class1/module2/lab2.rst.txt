Deploy Canary Test Policy
#########################

#. Create app1b.json

   - ``touch app1b.json``
   - use vscode to add the following code to **app1b.json**

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
             "policyEndpoint": "forward_policy",
             "pool": "blue_pool",
             "persistenceMethods": []
            },
            "blue_pool": {
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
            },
            "green_pool": {
            "class": "Pool",
            "monitors": [
            "http"
            ],
            "members": [{
                "shareNodes":true,
                "servicePort": 80,
                "serverAddresses": [
                    "10.1.10.5",
                    "10.1.10.10"
                ]
            }]
        },
        "forward_policy": {
            "class": "Endpoint_Policy",
            "rules": [{
                "name": "forward_to_pool",
                "conditions": [{
                "type": "httpUri",
                "path": {
                    "operand": "contains",
                    "values": ["about"]
                }
            }],
            "actions": [{
                "type": "forward",
                "event": "request",
                "select": {
                    "pool": {
                    "use": "green_pool"
                    }
                }
            }]
        }]
      }   
    }
    }
    }
    }

#. Modify **main.tf** to use **app1b.json**

   - use vscode to replace **app1a.json** with **app1b.json**

   .. code:: json

      resource "bigip_as3"  "tenant01_app1" {
         as3_json = "${file("app1b.json")}"
      }

#. Redeploy App1 services with blue and green pools

   - ``terraform plan``
   - ``terraform apply -auto-approve``

#. Confirm BIG-IP is now configured with multiple apps

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to view **app2** associated with blue and green pools

   .. image:: /_static/canary.png
       :height: 300px

   .. TIP:: 
      Creating multiple versions of your as3 json files allows for quick rollback to previous version if issues occur.
