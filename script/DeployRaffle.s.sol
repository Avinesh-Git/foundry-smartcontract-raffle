// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() public {
        deployContract();
    }

    uint256 subscriptionId;

    function deployContract() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        // if on local chain -> deploy mocks, get local config
        // if on sepolia -> get sepolia cofig
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        if (config.subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription(
                helperConfig
            );
            (subscriptionId, ) = createSubscription.createSubscription(
                config.vrfCoordinator,
                config.account
            );

            FundSubscription fundSubscription = new FundSubscription(
                helperConfig
            );
            fundSubscription.fundSubscription(
                config.vrfCoordinator,
                subscriptionId,
                config.link,
                config.account
            );
            helperConfig
                .getOrCreateAnvilEthConfig()
                .subscriptionId = subscriptionId;
        } else {
            subscriptionId = config.subscriptionId;
        }

        vm.startBroadcast(config.account);
        Raffle raffle = new Raffle(
            config.entranceFee,
            config.interval,
            config.vrfCoordinator,
            config.gasLane,
            subscriptionId,
            config.callbackGasLimit
        );
        vm.stopBroadcast();

        AddConsumer addConsumer = new AddConsumer(helperConfig);
        addConsumer.addConsumer(
            address(raffle),
            config.vrfCoordinator,
            subscriptionId,
            config.account
        );

        return (raffle, helperConfig);
    }
}
