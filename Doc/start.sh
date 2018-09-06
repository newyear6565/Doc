#! /bin/bash

sudo geth --datadir . --networkid 4224 --rpc --rpcport 8545 --port 30303 --rpccorsdomain="*" -rpcapi eth,web3,personal,net console 2> log.txt --dev --dev.period 1
