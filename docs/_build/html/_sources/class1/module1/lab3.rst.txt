Modify and Destroy App Services Configuration
#############################################

.. important::
   - Estimated completion time: 20 minutes

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

   .. image:: /_static/tapply.png
       :height: 300px

#. Confirm **app1_pool** now contains 2 pool members

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to view app1 services

   .. image:: /_static/app1w2pool.png
       :height: 300px

#. Destroy App1 services

   - ``terraform destroy -auto-approve``

   .. image:: /_static/destroy.png
       :height: 300px

#. Confirm App1 services no longer exist

   - Open client server Firebox Browser
   - Login to bigip (https://10.1.10.6)
   - Explore **Local Traffic -> Network Map** to view no app services