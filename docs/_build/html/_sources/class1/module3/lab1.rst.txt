Deploy AS3 WAF Policy
#####################

#. Confirm BIG-IP is not configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore Local Traffic -> Network Map to validate tenant_02 app services does not exist

#. Create main.tf to use terraform bigip provider

   - Open client server vscode termninal
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

#. Create variables.tf

   - ``touch variables.tf``
   - use vscode to add the following code to **variables.tf**

   .. code:: json

      variable "address" {}
      variable "username" {}
      variable "password" {}

#. Create terraform.tfvars

   - ``touch terraform.tfvars``
   - use vscode to add the following code to **terraform.tfvars**

   .. code:: json

      address = "10.1.1.6"
      username = "admin"
      password = "F5d3vops$"

#. Create app3.json

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
              "id": "example-04",
              "label": "Tenant 2",
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
	      			"pool": "web3000_pool",
		      		"policyWAF": {"use": "My_ASM_Policy"},
		      		"serverTLS": "webtls"
		      	},
                      "web3000_pool": {
                          "class": "Pool",
                          "monitors": [
                              "http"
                          ],
                          "members": [{
				      		"shareNodes": true,
			      			"servicePort": 3000,
                              "serverAddresses": [
			      				"10.1.10.5",
			      				"10.1.10.10"
				      		]
			      			}]
		      		},
	      			"My_ASM_Policy": {
		      			"class": "WAF_Policy",
		      			"url": "https://raw.githubusercontent.com/Larsende/Agility2020-AS3/masterimages/Common_test_policy__2020-1-13_9-38-13__bigip02.as3lab.com.xml",
		      			"ignoreChanges": true
	      			  },
      				"webtls": {
	      				"class": "TLS_Server",
      					"certificates": [{
	      					"certificate": "webcert"
      						}]
      				},
	      			"webcert": {
      					"class": "Certificate",
	      				"remark": "in practice we recommend using a passphrase",
      					"certificate": "-----BEGIN CERTIFICATE-----\nMIICnDCCAgWgAwIBAgIJAJ5n2b0OCEjwMA0GCSqGSIb3DQEBCwUAMGcxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApXYXNoaW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRQwEgYDVQQKDAtmNV9OZXR3b3JrczEbMBkGA1UEAwwSc2FtcGxlLmV4YW1wbGUubmV0MB4XDTE3MTEyNjE5NTAyNFoXDTE4MDIyNTE5NTAyNFowZzELMAkGA1UEBhMCVVMxEzARBgNVBAgMCldhc2hpbmd0b24xEDAOBgNVBAcMB1NlYXR0bGUxFDASBgNVBAoMC2Y1X05ldHdvcmtzMRswGQYDVQQDDBJzYW1wbGUuZXhhbXBsZS5uZXQwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALEsuXmSXVQpYjrZPW+WiTBjn491mwZYT7Q92V1HlSBtM6WdWlK1aZN5sovfKtOX7Yrm8xa+e4o/zJ2QYLyyv5O+t2EGN/4qUEjEAPY9mwJdfzRQy6Hyzm84J0QkTuUJ/EjNuPji3D0QJRALUTzu1UqqDCEtiN9OGyXEkh7uvb7BAgMBAAGjUDBOMB0GA1UdDgQWBBSVHPNrGWrjWyZvckQxFYWO59FRFjAfBgNVHSMEGDAWgBSVHPNrGWrjWyZvckQxFYWO59FRFjAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4GBAJeJ9SEckEwPhkXOm+IuqfbUS/RcziifBCTmVyE+Fa/j9pKSYTgiEBNdbJeBEa+gPMlQtbV7Y2dy8TKx/8axVBHiXC5geDML7caxOrAyHYBpnx690xJTh5OIORBBM/a/NvaR+P3CoVebr/NPRh9oRNxnntnqvqD7SW0U3ZPe3tJc\n-----END CERTIFICATE-----",
      					"privateKey": "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: AES-256-CBC,D8FFCE6B255601587CB54EC29B737D31\n\nkv4Fc3Jn0Ujkj0yRjt+gQQfBLSNF2aRLUENXnlr7Xpzqu0Ahr3jS1bAAnd8IWnsR\nyILqVmKsYF2DoHh0tWiEAQ7/y/fe5DTFhK7N4Wml6kp2yVMkP6KC4ssyYPw27kjK\nDBwBZ5O8Ioej08A5sgsLCmglbmtSPHJUn14pQnMTmLOpEtOsu6S+2ibPgSNpdg0b\nCAJNG/KHe+Vkx59qNDyDeKb7FZOlsX30+y67zUq9GQqJEDuysPJ2BUNP0IJXAjst\nFIt1qNoZew+5KDYs7u/lPxcMGTirUhgI84Jy4WcDvSOsP/tKlxj04TbIE3epmSKy\n+TihHkwY7ngIGtcm3Sfqk5jz2RXoj1/Ac3SW8kVTYaOUogBhn7zAq4Wju6Et4hQG\nRGapsJp1aCeZ/a4RCDTxspcKoMaRa97/URQb0hBRGx3DGUhzpmX9zl7JI2Xa5D3R\nmdBXtjLKYJTdIMdd27prBEKhMUpae2rz5Mw4J907wZeBq/wu+zp8LAnecfTe2nGY\nE32x1U7gSEdYOGqnwxsOexb1jKgCa67Nw9TmcMPV8zmH7R9qdvgxAbAtwBl1F9OS\nfcGaC7epf1AjJLtaX7krWmzgASHl28Ynh9lmGMdv+5QYMZvKG0LOg/n3m8uJ6sKy\nIzzvaJswwn0j5P5+czyoV5CvvdCfKnNb+3jUEN8I0PPwjBGKr4B1ojwhogTM248V\nHR69D6TxFVMfGpyJhCPkbGEGbpEpcffpgKuC/mEtMqyDQXJNaV5HO6HgAJ9F1P6v\n5ehHHTMRvzCCFiwndHdlMXUjqSNjww6me6dr6LiAPbejdzhL2vWx1YqebOcwQx3G\n-----END RSA PRIVATE KEY-----",
	      				"passphrase": {
	      				  "ciphertext": "ZjVmNQ==",
	      				  "protected": "eyJhbGciOiJkaXIiLCJlbmMiOiJub25lIn0"
      					}
      				}
      			}
      		}
      	}
      }

#. Deploy Tenant02 App3 services

   - ``terraform  init``
   - ``terraform plan``
   - ``terraform apply -auto-approve``

   .. image:: /_static/tapply.png
       :height: 300px

#. Confirm BIG-IP is now configured

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore Local Traffic -> Network Map to view tenant02 app3 services

   .. image:: /_static/tapply.png
       :height: 300px
