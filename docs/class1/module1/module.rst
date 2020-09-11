Lab 1 - Basic BIG-IP Administration with Terraform
==================================================

You will walk through a typical device onboarding workflow to deploy base network and app services configurations

.. important::
   - Estimated completion time: 30 minutes

Access Lab Environment
~~~~~~~~~~~~~~~~~~~~~~

#. Log in to F5's `[Unified Demo Framework Portal] <https://udf.f5.com>`__

#. Deploy the **DevOps Base** blueprint

   .. image:: /_static/deploybp.png
      :scale: 40 %

#. Under components, click the access dropdown on the **client ubuntu** server, then click **VS CODE**.  We will use this for making edits to the terraform files.

   .. image:: /_static/vscode.png
      :scale: 40 %

#. Open a **New Terminal** in **VS Code** to run commands in this lab

   .. image:: /_static/newterm.png
      :scale: 40 %

#. Update **Terraform** in **VS Code** to version 13.x

   .. image:: /_static/tfupdate.png
      :scale: 40 %

#. Under components, click the access dropdown on the **client ubuntu** server, then click **Firefox**

   .. image:: /_static/firefox.png
      :scale: 40 %

.. toctree::
   :maxdepth: 1
   :glob:

   lab*
