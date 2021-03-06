#!/usr/bin/env bash

mkdir -p flats
mkdir -p flats
rm -rf flats/*
./node_modules/.bin/truffle-flattener contracts/CakePool.sol > flats/CakePool.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_CakeBNB.sol > flats/CakeLP_CakeBNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_UST_BUSD.sol > flats/CakeLP_UST_BUSD.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_BUSD_BNB.sol > flats/CakeLP_BUSD_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_LTC_BNB.sol > flats/CakeLP_LTC_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_USDC_BUSD.sol > flats/CakeLP_USDC_BUSD.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_BSCX_BNB.sol > flats/CakeLP_BSCX_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_TEN_BNB.sol > flats/CakeLP_TEN_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_REEF_BNB.sol > flats/CakeLP_REEF_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_VAI_BUSD.sol > flats/CakeLP_VAI_BUSD.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_ADA_BNB.sol > flats/CakeLP_ADA_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_USDT_BUSD.sol > flats/CakeLP_USDT_BUSD.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_TWT_BNB.sol > flats/CakeLP_TWT_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_XVS_BNB.sol > flats/CakeLP_XVS_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_ETH_BNB.sol > flats/CakeLP_ETH_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_BTCB_BNB.sol > flats/CakeLP_BTCB_BNB.sol
./node_modules/.bin/truffle-flattener contracts/CakeLP_USDT_BNB.sol > flats/CakeLP_USDT_BNB.sol
./node_modules/.bin/truffle-flattener contracts/JetFuelLP_FUEL_BNB.sol > flats/JetFuelLP_FUEL_BNB.sol