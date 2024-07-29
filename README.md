
# Deploy Brahma application

This repository contains the deployment for the BRAHMA EHR system

## Prerequisites
Before setting up the project, ensure you have the following installation:
* **Git** (for cloning the repository)
* **Node.js** (v18.19.1)
* **npm** (v10.2.4)
* **Redis** server (v6.0.16)
* **RabbitMQ** server (v3.9.13)

## Installation
* **Clone these repository**

    ```git clone https://github.com/Brahma-iit/brahma_server.git```

## Run the application

* **Step-1**: 

    Navigate to the following directory:

    ```cd brahma_server```

* **Step-2**:

    Give permission to script file

    ```sudo chmod +x script.sh```

* **Step-3**:        
    
    Update the channel name inside script file

* **Step-4** :

    Run the script file

    ```./script.sh```

* **Step-5**:

    Check the services is running or not

    ```docker ps -a```
