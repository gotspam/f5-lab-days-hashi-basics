Lab 1 - Basic BIG-IP Administration with Terraform
==================================================

You will walk through a typical device onboarding workflow to deploy base network and app services configurations

.. important::
   - Estimated completion time: 30 minutes

Access Lab Environment
~~~~~~~~~~~~~~~~~~~~~~

#. Log in to F5's `[Unified Demo Framework Portal] <https://udf.f5.com>`__

   - Select F5 or Non F5 User then enter credentials.

   .. image:: /_static/udf.png
      :scale: 25 %

#. Launch the **Channel - F5 and Terraform Basics** course

   .. image:: /_static/course.png
      :scale: 40 %

#. Click **Join** course, then click **Deployment** to access your lab envirnment.

   .. image:: /_static/deployment.png
      :scale: 40 %

#. Click the **ACCESS** dropdown on the **client** ubuntu server, then click **VS CODE**. We will use this for making edits to the terraform files

   .. image:: /_static/vscode.png
      :scale: 40 %

#. Open a **New Terminal** in **VS Code** to run the lab commands in the bottom window

   .. image:: /_static/newterm.png
      :scale: 50 %

#. Update **Terraform** in **VS Code** to version 13.x

   - run ``terraform -version`` in **VS Code terminal** on bottom of window
   - if terraform version is **v0.13.2** then **skip to step 7** else continue with upgrade process
   - ``wget --quiet --continue --show-progress https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip``
   - ``sudo unzip terraform_0.13.2_linux_amd64.zip``
   - ``sudo mv terraform /usr/local/bin``
   - ``terraform -version`` to confirm **v0.13.2**
   - ``rm terraform_0.13.2_linux_amd64.zip``

   .. image:: /_static/tfupdate.png
      :scale: 40 %

#. Under components, click the access dropdown on the **client ubuntu** server, then click **Firefox**

   .. image:: /_static/firefox.png
      :scale: 25 %

   .. image:: /_static/firefox1.png
      :scale: 25 %

#. Login to BIG-IP management interface (https://10.1.1.6) admin : F5d3vops

   .. NOTE::
      Ctrl+c and Ctrl+v does not work with the firefox web instance.  You must paste into firefox cliboard and submit, then rtclk paste to paste as shown in the images below

   .. image:: /_static/clipboard.png
      :scale: 25 %

   .. image:: /_static/paste.png
      :scale: 25 %

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
