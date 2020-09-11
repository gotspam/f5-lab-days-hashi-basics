Getting Started
---------------

Please follow the instructions provided by the instructor to start your
lab and access your jump host.

.. NOTE::
	 All work for this lab will be performed exclusively from the Windows
	 jumphost. No installation or interaction with your local system is
	 required.

Lab Topology
~~~~~~~~~~~~

The following components have been included in your lab environment:

- 2 x BIG-IP virtual appliances (15.0.x)
- 1 Ubuntu client server running:

  - vscode

  - firefox

- 1 Ubuntu application server running:

  - NGINX Demo App (App port 8080)

  - OWASP Juice Shop (App port 3000)


Network Addressing
^^^^^^^^^^^^^^^^^^

The following table lists VLANS, IP Addresses and Credentials for all
components:

.. list-table::
    :widths: 20 20 20 20 20
    :header-rows: 1
    :stub-columns: 0

    * - **Component**
      - **Management**
      - **Internal**
      - **External**
      - **Additional IP**
    * - Client Server
      - 10.1.1.4
      - 10.1.10.4
      - 10.1.20.4
      - none
    * - App Server
      - 10.1.1.5
      - 10.1.10.5
      - none
      - 10.1.10.10
    * - BIG-IP1
      - 10.1.1.6
      - 10.1.10.6
      - 10.1.20.6
      - 10.1.20.20
    * - BIG-IP2
      - 10.1.1.7
      - 10.1.10.7
      - 10.1.20.7
      - 10.1.20.10