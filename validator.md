![Alt Text](https://i.ibb.co/Mg6tGgw/320326989-6eca238f-cd35-411b-9c5a-857fbd80dd33.png)


# Quick Links

<ul style="list-style-type: none; padding: 0; text-align: center;">
  <li style="display: inline-block; margin: 5px;">
    <a href="https://0g.ai/" style="
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #c62d1f;
        border: 1px solid #d02718;
        border-radius: 18px;
        text-align: center;
        text-decoration: none;
        box-shadow: 3px 4px 0px 0px #8a2a21;
        font-family: Arial;
        text-shadow: 0px 1px 0px #810e05;
        cursor: pointer;
    ">Official Website</a>
  </li>
  <li style="display: inline-block; margin: 5px;">
    <a href="https://twitter.com/0G_labs" style="
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #1DA1F2;
        border: 1px solid #1A91DA;
        border-radius: 18px;
        text-align: center;
        text-decoration: none;
        box-shadow: 3px 4px 0px 0px #0C7ABF;
        font-family: Arial;
        text-shadow: 0px 1px 0px #055A8E;
        cursor: pointer;
    ">Twitter X</a>
  </li>
  <li style="display: inline-block; margin: 5px;">
    <a href="https://docs.0g.ai/0g-doc/run-a-node/validator-node" style="
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #c62d1f;
        border: 1px solid #d02718;
        border-radius: 18px;
        text-align: center;
        text-decoration: none;
        box-shadow: 3px 4px 0px 0px #8a2a21;
        font-family: Arial;
        text-shadow: 0px 1px 0px #810e05;
        cursor: pointer;
    ">Official Docs</a>
  </li>
  <li style="display: inline-block; margin: 5px;">
    <a href="https://t.me/web3_0glabs" style="
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #0088cc;
        border: 1px solid #0077b5;
        border-radius: 18px;
        text-align: center;
        text-decoration: none;
        box-shadow: 3px 4px 0px 0px #005f87;
        font-family: Arial;
        text-shadow: 0px 1px 0px #004664;
        cursor: pointer;
    ">0G Telegram</a>
  </li>
  <li style="display: inline-block; margin: 5px;">
    <a href="https://discord.com/invite/0glabs" style="
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #ffffff;
        background-color: #7289da;
        border: 1px solid #5865f2;
        border-radius: 18px;
        text-align: center;
        text-decoration: none;
        box-shadow: 3px 4px 0px 0px #4752b2;
        font-family: Arial;
        text-shadow: 0px 1px 0px #2c3d66;
        cursor: pointer;
    ">0G Discord</a>
  </li>
</ul>

##
- **RPC**: [https://rpc.0g-test.paknodesarmy.xyz/](https://rpc.0g-test.paknodesarmy.xyz/)
- **API**: [https://api.0g-test.paknodesarmy.xyz/](https://api.0g-test.paknodesarmy.xyz/)
- **JSON-RPC**: [https://jsonrpc.0g-test.paknodesarmy.xyz/](https://jsonrpc.0g-test.paknodesarmy.xyz/)
- **Explorer**: [https://explorer.paknodesarmy.xyz/0g/staking](https://explorer.paknodesarmy.xyz/0g/staking)

##
| Hardware Requirement   |         |
|------------------------|-------------------------------|
| **RAM**                | 64GB                          |
| **CPU**                | 8-Core                        |
| **Disk**               | 1 TB NVME SSD                 |
| **Bandwidth**          | 100 MBps (Download/Upload)    |

##
### Step 1 ; 0g full node installation
Copy&Paste our OG FullNode auto installation script
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Paknodesarmy/scripts/main/0g/0g_validator.sh)"
```
### When you copy paste this script, within a few seconds you will be asked to "Enter node name" you have to give the name with which you gonna create your validator. 

<a href="https://ibb.co/kxmjGVW"><img src="https://i.ibb.co/nbP9wq5/enter-valname.jpg" alt="enter-valname" border="0"></a>

### now wait for the synchronization process to complete... you can track block hight at our explorer https://explorer.paknodesarmy.xyz/0g/staking

##

### Once the synchronization process is complete, you can proceed to step 2.

## Step 2; Create validator

#### Create a wallet, don’t forget to save the mnemonic:
```bash
0gchaind keys add wallet --eth
```
### If you already have wallet, you can recover with this command:
```bash
0gchaind keys add wallet --recover --eth
```
#### Once you have created or imported a wallet, the next step is to get the public address which starts with 0x, run the following command to get your private key.
```bash
0gchaind keys unsafe-export-eth-key wallet
```
#### now import the returned private key to a web3 wallet (eg.Metamask) and copy eth address. and Request testnet tokens at https://faucet.0g.ai/

### Create a validator : change "Validator-Army" to the name with which you want to create your validator
```bash
0gchaind tx staking create-validator \
  --amount=1000000ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker="Validator-Army" \
  --chain-id="zgtendermint_16600-2" \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas=auto \
  --gas-adjustment=1 \
  --identity="" \
  --website="-" \
  --security-contact="-" \
  --from=wallet -y
```

##

##
### Node Management Commands
#### View Logs
To view the logs of your 0g node, use the following command:
```bash
sudo journalctl -u 0gd -f
```
#### Restart Node
To restart your 0g node, use the following command:
```bash
sudo systemctl restart 0gd
```
#### Check Node Status
To check the status of your node, use the following command:
```bash
curl localhost:26657/status
```
#### To find out if your node is synchronized (if the result is false, it means the node is synchronized), use the following command:
```bash
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```
#### Find Your Valoper Address
```bash
0gchaind keys show wallet --bech val -a
```
#### Delegate Tokens
in order to delegate tokens (to increase your stake, delegate to your valoper address), use the following command:
```bash
0gchaind tx staking delegate YOUR_VALOPER_ADDRESS 1000000ua0gi --from wallet --chain-id zgtendermint_16600-2 --gas="500000" --gas-prices="50ua0gi"
```
#### Remove/delete node
To remove or delete your 0g node, use the following commands:
```bash
sudo systemctl stop 0gchaind
sudo systemctl disable 0gchaind
sudo rm /etc/systemd/system/0gchaind.service
rm -rf $HOME/.0gchain
sudo rm /usr/local/bin/0gchain
```

