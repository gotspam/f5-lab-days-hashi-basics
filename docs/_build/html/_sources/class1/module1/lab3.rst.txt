Modify and Destroy App Services Configuration
#############################################

In this section you will conduct basic add and delete administration using terraform

#. Add 2nd Pool Member to service App1

   - use vscode to add the following code to **app1.tf**

   .. code:: json

      resource "bigip_ltm_node" "node2" {
        name    = "/Common/10.1.10.10"
        address = "10.1.10.10"
      }

      resource "bigip_ltm_pool_attachment" "attach_node2" {
        pool = "/Common/app1_pool"
        node = "/Common/10.1.10.10:80"
      }

   .. HINT:: 
      Follow same syntax and spacing formats for best results.  Notice existing bigip_ltm_node and bigip_ltm_pool_attachment resource dependencies.

#. Redeploy App1 services

   - ``terraform plan``
   - ``terraform apply -auto-approve``

   .. image:: /_static/t1apply.png
       :height: 300px

   .. NOTE:: 
      The apply will most likely result with and error due to resource dependencies.  If so, you may simply run **terraform apply** again. However I recommend you resolve the dependencies as hinted in the previous step to ensure consistency.

#. Confirm **app1_pool** now contains 2 pool members

   - Explore BIG-IP GUI **Local Traffic -> Network Map** to view app1 services

   .. image:: /_static/app1w2pool.png
       :height: 300px

#. Destroy **app1_vs** resource

   - ``terraform destroy -target=bigip_ltm_virtual_server.http -auto-approve``

   .. image:: /_static/vsdestroy.png
       :height: 300px

#. Confirm App1 services no longer exist

   - Explore **Local Traffic -> Virtual Servers, Pools and Nodes**

   .. image:: /_static/vs.png
       :height: 150px

   .. image:: /_static/pool.png
       :height: 160px

   .. image:: /_static/node.png
       :height: 150px

#. Destroy all services

   - ``terraform destroy -auto-approve``

   .. image:: /_static/destroy.png
       :height: 300px

#. Confirm all services no longer exist

   - Explore BIG-IP GUI **Local Traffic -> Virtual Servers, Pools and Nodes** to view no app services