
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
    
    ```git clone https://github.com/Brahma-iit/auth.git```

    ```git clone https://github.com/Brahma-iit/backend.git```

    ```git clone https://github.com/Brahma-iit/backend-event-manager.git```

    ```git clone https://github.com/Brahma-iit/notificaiton-service.git```

    ```git clone https://github.com/Brahma-iit/otp-service.git```

    ```git clone https://github.com/Brahma-iit/nginx.git```

    ```git clone https://github.com/Brahma-iit/fabric-samples.git```

    ```git clone https://github.com/Brahma-iit/brahma_server.git```


## Run the application

* **Step-1**: 

    Navigate to the following directory:

    ```cd fabric-samples```

* **Step-2**:

    Shut down the running network

    ```./networkDown.sh```

* **Step-3**:        
    
    Start the new network with the specified channel name
        
    ```./startFabric.sh channelName```

* **Step-4** :

    Add Org3 to the network with the specified channel name, ensuring that Org3 is properly added to the network

    ```./addOrg.sh channelName```

* **Step-5**:

    Install all chaincodes in the network using the deployChaincode script

    ```./deployChaincode.sh channelName contractName chaincodeSequence chaincodeVersion```

* **Step-6**:

    Rename the .env.example file to .env in all other repositories

* **Step-7**:
    
    Update the **HOST** and **CHANNEL_NAME** variables in the .env file based on your system's IP address and the specified channel name

* **Step-8**:

    Navigate to the brahma_server repository

    ```cd brahma_server```

* **Step-9**:

    Run the services

    ```docker compose -f docker-compose.yaml -d --build```

* **Step-10**:

    Check the services is running or not

    ```docker ps -a```
