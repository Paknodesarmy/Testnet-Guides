![Alt Text](https://i.ibb.co/Mg6tGgw/320326989-6eca238f-cd35-411b-9c5a-857fbd80dd33.png)


## Learn about the project [Visit Website](https://0g.ai/)
## Follow 0G on: [X](https://twitter.com/0G_labs)
## Official Docs to [Validator](https://0glabs.gitbook.io/0g-doc/run-a-node/validator-node)
## join: [0G official telegram](https://t.me/web3_0glabs)
## Join their [Discord](https://discord.gg/0glabs)

# OG node installation guide.

## Recommended Hardware Requirements for this node run.

|   SPEC      |       Recommended        |
| :---------: | :-----------------------:|
|   **CPU**   |        8 Cores           |
|   **RAM**   |        16 GB             |
| **Storage** |        260 Nvme          |
| **NETWORK** |        100 Mbps          |
|   **OS**    |   Ubuntu 20.04 - 22.04   |


## install dependencies
```bash
sudo apt update && \
sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

```
## install Go
```bash
cd $HOME
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

```
# Replace (Node_name) and (wallet_name) with your own.
```bash
echo "export WALLET="wallet_name"" >> $HOME/.bash_profile
echo "export MONIKER="Node_name"" >> $HOME/.bash_profile
echo "export OG_CHAIN_ID="zgtendermint_9000-1"" >> $HOME/.bash_profile
echo "export OG_PORT="47"" >> $HOME/.bash_profile
source $HOME/.bash_profile

```
## download the binary.
```bash
cd $HOME
rm -rf 0g-evmos
git clone https://github.com/0glabs/0g-evmos.git
cd 0g-evmos
git checkout v1.0.0-testnet
make build
mv $HOME/0g-evmos/build/evmosd $HOME/go/bin/
```
## config and init app
```bash
evmosd config node tcp://localhost:${OG_PORT}657
evmosd config keyring-backend os
evmosd config chain-id zgtendermint_9000-1
```
# Replace (Node_name) with your own
```bash
evmosd init "Node_name" --chain-id zgtendermint_9000-1
```
## download genesis and addrbook
```bash
wget -O $HOME/.evmosd/config/genesis.json https://testnet-files.itrocket.net/og/genesis.json
wget -O $HOME/.evmosd/config/addrbook.json https://testnet-files.itrocket.net/og/addrbook.json
```
## set seeds and peers
```bash
SEEDS="c9b8e7e220178817c84c7268e186b231bc943671@og-testnet-seed.itrocket.net:47656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.evmosd/config/config.toml
```
## set custom ports in app.toml
```bash
sed -i.bak -e "s%:1317%:${OG_PORT}317%g;
s%:8080%:${OG_PORT}080%g;
s%:9090%:${OG_PORT}090%g;
s%:9091%:${OG_PORT}091%g;
s%:8545%:${OG_PORT}545%g;
s%:8546%:${OG_PORT}546%g;
s%:6065%:${OG_PORT}065%g" $HOME/.evmosd/config/app.toml
```
## set custom ports in config.toml file
```bash
sed -i.bak -e "s%:26658%:${OG_PORT}658%g;
s%:26657%:${OG_PORT}657%g;
s%:6060%:${OG_PORT}060%g;
s%:26656%:${OG_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${OG_PORT}656\"%;
s%:26660%:${OG_PORT}660%g" $HOME/.evmosd/config/config.toml
```
## config pruning
```bash
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.evmosd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.evmosd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.evmosd/config/app.toml
```
## set minimum gas price, enable prometheus and disable indexing
```bash
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0agnet"|g' $HOME/.evmosd/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.evmosd/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.evmosd/config/config.toml
```
## create service file, "so that your node can run in the background"
```bash
sudo tee /etc/systemd/system/evmosd.service > /dev/null <<EOF
[Unit]
Description=Og node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.evmosd
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
## reset and download the snapshot
```bash
evmosd tendermint unsafe-reset-all --home $HOME/.evmosd
if curl -s --head curl https://testnet-files.itrocket.net/og/snap_og.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://testnet-files.itrocket.net/og/snap_og.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.evmosd
    else
  echo no have snap
fi
```
## now enable and start the service.
```bash
sudo systemctl daemon-reload
sudo systemctl enable evmosd
sudo systemctl restart evmosd && sudo journalctl -u evmosd -f
```
## check sync status, once your node is fully synced, the output should be "false"
```bash
evmosd status 2>&1 | jq .SyncInfo
```
## Create a wallet, with the name you chose earlier
```bash
evmosd keys add wallet_name
```

### now before creating a validator, you need to fund your wallet, for that you need a EVM campitable wallet address, so you need the private key for your EVM/MM wallet

## Use this command to get Private Key for EVM/MM wallet
```bash
evmosd keys unsafe-export-eth-key wallet_nam
```
### once you have your private key, import it in EVM/MM wallet and get the ETH address from there and collect the faucet from this site "https://faucet.0g.ai/"

## now create validator, by replacing (Node_name) and (wallet_name) 

evmosd tx staking create-validator \
--amount 1000000aevmos \
--from $WALLET \
--commission-rate 0.1 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--pubkey $(evmosd tendermint show-validator) \
--moniker "Node_name" \
--identity "wallet_name" \
--details "" \
--chain-id zgtendermint_9000-1 \
--gas 500000 --gas-prices 99999aevmos \
-y

## Delegate to your validator
```bash
evmosd tx staking delegate $(evmosd keys show wallet_name --bech val -a) 1000000aevmos --from wallet_name --chain-id zgtendermint_9000-1 --gas 500000 --gas-prices 99999aevmos -y
```



