#!/bin/bash

echo -e "\033[0;35m"
echo " /$$$$$$$           /$$       /$$   /$$                 /$$                      /$$$$$$                                   "
echo " | $$__  $$         | $$      | $$$ | $$                | $$                     /$$__  $$                                  "
echo " | $$  \ $$ /$$$$$$ | $$   /$$| $$$$| $$  /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$$| $$  \ $$  /$$$$$$  /$$$$$$/$$$$  /$$   /$$"
echo " | $$$$$$$/|____  $$| $$  /$$/| $$ $$ $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/| $$$$$$$$ /$$__  $$| $$_  $$_  $$| $$  | $$"
echo " | $$____/  /$$$$$$$| $$$$$$/ | $$  $$$$| $$  \ $$| $$  | $$| $$$$$$$$|  $$$$$$ | $$__  $$| $$  \__/| $$ \ $$ \ $$| $$  | $$"
echo " | $$      /$$__  $$| $$_  $$ | $$\  $$$| $$  | $$| $$  | $$| $$_____/ \____  $$| $$  | $$| $$      | $$ | $$ | $$| $$  | $$"
echo " | $$     |  $$$$$$$| $$ \  $$| $$ \  $$|  $$$$$$/|  $$$$$$$|  $$$$$$$ /$$$$$$$/| $$  | $$| $$      | $$ | $$ | $$|  $$$$$$$"
echo " |__/      \_______/|__/  \__/|__/  \__/ \______/  \_______/ \_______/|_______/ |__/  |__/|__/      |__/ |__/ |__/ \____  $$"
echo "                                                                                                                  /$$  | $$"
echo "                                                                                                                 |  $$$$$$/ "
echo "                                                                                                                  \______/  "
echo -e "\e[0m"

# Wait for 2 seconds
sleep 2

# Read node name from user input
read -p "Enter node name: " MONIKER

# Append environment variables to .bash_profile
cat << EOF >> $HOME/.bash_profile
export MONIKER="$MONIKER"
export CHAIN_ID="zgtendermint_16600-2"
export WALLET_NAME="wallet"
export RPC_PORT="26657"
EOF

# Source .bash_profile to apply environment variables
source $HOME/.bash_profile

# Print node name
echo '================================================='
echo -e "Your node name: \e[1m\e[32m$MONIKER\e[0m"
echo '================================================='

# Update and upgrade system packages
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y

# Install necessary dependencies
echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
sudo apt install -y curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential bsdmainutils git make ncdu gcc chrony liblz4-tool snapd

# Install Go if not already installed
echo -e "\e[1m\e[32mInstalling Go... \e[0m" && sleep 1
GO_VERSION="1.22.0"
wget "https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
rm "go$GO_VERSION.linux-amd64.tar.gz"
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
sleep 1

# Download and build 0g-chain binaries
echo -e "\e[1m\e[32m3. Downloading and building 0g-chain binaries... \e[0m" && sleep 1
git clone -b v0.2.3 https://github.com/0glabs/0g-chain.git
cd 0g-chain
make install
0gchaind version

# Initialize 0gchain node
echo -e "\e[1m\e[32mInitializing 0gchain node... \e[0m" && sleep 1
0gchaind init $MONIKER --chain-id $CHAIN_ID
0gchaind config chain-id $CHAIN_ID
0gchaind config node tcp://localhost:$RPC_PORT
0gchaind config keyring-backend os

# Download genesis file
rm $HOME/.0gchain/config/genesis.json
wget https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json -O $HOME/.0gchain/config/genesis.json

# Configure seeds and persistent peers
SEEDS="81987895a11f6689ada254c6b57932ab7ed909b6@54.241.167.190:26656,010fb4de28667725a4fef26cdc7f9452cc34b16d@54.176.175.48:26656,e9b4bc203197b62cc7e6a80a64742e752f4210d5@54.193.250.204:26656,68b9145889e7576b652ca68d985826abd46ad660@18.166.164.232:26656"
PEERS="6dbb0450703d156d75db57dd3e51dc260a699221@152.53.47.155:13456,1bf93ac820773970cf4f46a479ab8b8206de5f60@62.171.185.81:12656,df4cc52fa0fcdd5db541a28e4b5a9c6ce1076ade@37.60.246.110:13456,66d59739b6b4ff0658e63832a5bbeb29e5259742@144.76.79.209:26656,76cc5b9beaff9f33dc2a235e80fe2d47448463a7@95.216.114.170:26656,adc616f440155f4e5c2bf748e9ac3c9e24bf78ac@51.161.13.62:26656,cd662c11f7b4879b3861a419a06041c782f1a32d@89.116.24.249:26656,40cf5c7c11931a4fdab2b721155cc236dfe7a809@84.46.255.133:12656,11945ced69c3448adeeba49355703984fcbc3a1a@37.27.130.146:26656,c02bf872d61f5dd04e877105ded1bd03243516fb@65.109.25.252:12656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.0gchain/config/config.toml
sed -i "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

# Set minimum gas price
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml

# Create systemd service for 0gchain node
sudo tee /etc/systemd/system/0gd.service > /dev/null << EOF
[Unit]
Description=0G Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which 0gchaind) start --home $HOME/.0gchain
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Start 0gchain node service
sudo systemctl daemon-reload && sudo systemctl enable 0gd && sudo systemctl restart 0gd && sudo journalctl -u 0gd -f -o cat

# Print setup finished message
echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running service:: sudo journalctl -u 0gd -f -o cat'
echo -e "Check the node is running: sudo systemctl status 0gd.service"
echo -e "Stop your 0gchain node: sudo systemctl stop 0gd.service"
echo -e "Start your 0gchain node: sudo systemctl start 0gd.service"
