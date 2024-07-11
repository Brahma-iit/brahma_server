#!/bin/bash

CHANNEL_NAME="channel4000"

# Function to get IP address
get_ip_address() {
    hostname -I | cut -d' ' -f1
}

# Function to create .env file with IP address
create_env_file() {
    ip_address=$(get_ip_address)

    cat <<EOF > .env
AUTH_PORT=9000
BACKEND_PORT=9001
OTP_PORT=9002
EVENT_MANAGER_PORT=9003
NOTIFICATION_PORT=9004
WEBSOCKET_PORT=2000
RABBITMQ_URL=amqp://root:secretPassword@$ip_address:5672
RABBIT_MQ_HOST=tgaswnvp
RABBIT_MQ_PASSWORD=oRV8CKzlk8IFl8aNp6_FajlwF3XETNfz
HOST=$ip_address:80
MONGODB_AUTH_DB_URL=mongodb+srv://mgtbrahma:brahma123@brahmacluster.pq8zmgz.mongodb.net/auth?retryWrites=true&w=majority&appName=brahmaCluster
MONGODB_BACKEND_DB_URL=mongodb+srv://mgtbrahma:brahma123@brahmacluster.pq8zmgz.mongodb.net/backend?retryWrites=true&w=majority&appName=brahmaCluster
MONGODB_NOTIFICATION_DB_URL=mongodb+srv://mgtbrahma:brahma123@brahmacluster.pq8zmgz.mongodb.net/notification?retryWrites=true&w=majority&appName=brahmaCluster
JWT_SECRET_KEY=xZ2ii7PjwfxsYjB1yndnZpVOjqIqz1kJplUmn/pTZICBHgHeat4pYHDDcUXK9rv+5EODmkeaXgf2bqgJdLPvyA==
TWILIO_ACCOUNT_SID=AC43713fd9a0afbfdd2bd1a7eca2ae0d64
TWILIO_AUTH_TOKEN=cc92cff884deffbc856e76fc20dcdb80
TWILIO_MOBILE_NUMBER=+12409492395
ADMIN_EMAIL_HOST=mgtbrahma@gmail.com
ADMIN_EMAIL_HOST_PASS=rkeheikjcpuvesoa
REDIS_USERNAME=root
REDIS_PASSWORD=secretPassword
REDIS_HOST=$ip_address
AUTH_REDIS_PORT=6380
BACKEND_REDIS_PORT=6379
CHANNEL_NAME=$CHANNEL_NAME
EOF
}

# Function to update development configuration IP addresses in nginx config
update_dev_conf_ip() {
    ip_address=$(get_ip_address)
    sed -i "s/server_name [0-9\.]\+/server_name $ip_address/g" ../nginx/dev.conf
    sed -i "s|proxy_pass http://[0-9\.]\+:9000|proxy_pass http://$ip_address:9000|g" ../nginx/dev.conf
    sed -i "s|proxy_pass http://[0-9\.]\+:9001|proxy_pass http://$ip_address:9001|g" ../nginx/dev.conf
    sed -i "s|proxy_pass http://[0-9\.]\+:9002|proxy_pass http://$ip_address:9002|g" ../nginx/dev.conf
    sed -i "s|proxy_pass http://[0-9\.]\+:9003|proxy_pass http://$ip_address:9003|g" ../nginx/dev.conf
    sed -i "s|proxy_pass http://[0-9\.]\+:9004|proxy_pass http://$ip_address:9004|g" ../nginx/dev.conf
}

# Install necessary dependencies
# sudo apt update
# sudo apt install -y git docker.io docker-compose npm jq
# sudo snap install go --classic

cd ..
# Install Hyperledger Fabric binaries and Docker images
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh
./install-fabric.sh d b

# Clone the fabric-network repository
git clone git@github.com:Brahma-iit/fabric-network.git
if [ $? -ne 0 ]; then
    echo "Failed to clone fabric-network repository"
    exit 1
fi

# Copy binaries to fabric-network directory
sudo cp -r ./bin fabric-network/

# Install NPM dependencies for all sub-projects
cd fabric-network
npm install

# List of JavaScript directories to install dependencies
declare -a js_dirs=("downloadEhr/javascript"
                    "genLabReport/javascript"
                    "genPrescription/javascript"
                    "registerDoctor/javascript"
                    "registerPatient/javascript"
                    "registerStaff/javascript"
                    "shareEhr/javascript"
                    "uploadPrescription/javascript")

for dir in "${js_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "Navigating to $dir"
        cd "$dir"
        echo "Installing npm dependencies in $dir"
        npm i
        cd - > /dev/null
    else
        echo "Directory $dir does not exist. Skipping."
    fi
done

# Start the Fabric network and add organization
sudo ./startFabric.sh $CHANNEL_NAME
sudo ./addOrg.sh $CHANNEL_NAME

# Deploy chaincodes
for chaincode in registerPatient registerDoctor registerStaff genPrescription genLabReport shareEhr downloadEhr uploadPrescription; do
    sudo ./deployChaincode.sh $CHANNEL_NAME $chaincode 1 1
done

# Clone Brahma repositories and create .env files
for repo in auth backend backend-event-manager notificaiton-service otp-service; do
    git clone git@github.com:Brahma-iit/$repo.git ../$repo
    cd ../$repo
    create_env_file
    cd -
done

# Clone and configure nginx repository
git clone git@github.com:Brahma-iit/nginx.git ../nginx
cd ../nginx
update_dev_conf_ip

# Clone brahma_server repository and start Docker Compose
# git clone git@github.com:Brahma-iit/brahma_server.git ../brahma_server
cd ../brahma_server
sudo docker-compose up -d

