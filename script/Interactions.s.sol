//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {HelperConfig, codeConstants} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    HelperConfig public helperConfig; //*

    constructor(HelperConfig _helperConfig) {
        //*
        helperConfig = _helperConfig;
    }

    function CreateSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        address vrfCoordinator = config.vrfCoordinator; //*
        address account = config.account;
        (uint256 subId, ) = createSubscription(vrfCoordinator, account);
        return (subId, vrfCoordinator);
    }

    function createSubscription(
        address vrfCoordinator,
        address account
    ) public returns (uint256, address) {
        console2.log("creating subscription on chain id:", block.chainid);
        vm.startBroadcast(account);
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator)
            .createSubscription();
        vm.stopBroadcast();

        console2.log("your subscription id :", subId);
        console2.log(
            "please update your subscription Id in you HelperConfig.s.sol"
        );
        return (subId, vrfCoordinator);
    }

    function run() public {
        CreateSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script, codeConstants {
    uint256 public constant FUND_AMOUNT = 3 ether;
    HelperConfig public helperConfig;

    constructor(HelperConfig _helperConfig) {
        helperConfig = _helperConfig;
    }

    function fundSubscriptionUsingConfig() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        address vrfCoordinator = config.vrfCoordinator;
        uint256 subscriptionId = config.subscriptionId;
        address linkToken = config.link;
        address account = config.account;
        fundSubscription(vrfCoordinator, subscriptionId, linkToken, account);
    }

    function fundSubscription(
        address vrfCoordinator,
        uint256 subscriptionId,
        address linkToken,
        address account
    ) public {
        console2.log("funding subscription:", subscriptionId);
        console2.log("using vrfCoordinator:", vrfCoordinator);
        console2.log("on chain id:", block.chainid);

        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subscriptionId,
                FUND_AMOUNT * 100
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast(account);
            LinkToken(linkToken).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subscriptionId)
            );
            vm.stopBroadcast();
        }
    }

    function run() public {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    HelperConfig public helperConfig;

    constructor(HelperConfig _helperConfig) {
        helperConfig = _helperConfig;
    }

    function addConsumerUsingConfig(address mostRecentlyDeployed) public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        uint256 subId = config.subscriptionId;
        address vrfCoordinator = config.vrfCoordinator;
        address account = config.account;
        addConsumer(mostRecentlyDeployed, vrfCoordinator, subId, account);
    }

    function addConsumer(
        address contractToAddtoVrf,
        address vrfCoordinator,
        uint256 subId,
        address account
    ) public {
        console2.log("Adding consumer contract:", contractToAddtoVrf);
        console2.log("To vrfcoordinator", vrfCoordinator);
        console2.log("on chain id:", block.chainid);
        vm.startBroadcast(account);
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(
            subId,
            contractToAddtoVrf
        );
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(mostRecentyDeployed);
    }
}
