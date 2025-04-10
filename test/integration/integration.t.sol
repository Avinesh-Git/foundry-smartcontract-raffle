// integration tests are used to test the scripts.
//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {HelperConfig, codeConstants} from "script/HelperConfig.s.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

contract integration is Test, codeConstants {
    HelperConfig public helperConfig;
    LinkToken public linkToken;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10e18;

    address vrfCoordinator;
    uint256 subId;
    address account;

    // address returnedvrfCoordinator;

    function setUp() external {
        helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vrfCoordinator = config.vrfCoordinator;
        linkToken = LinkToken(config.link);
        account = config.account;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);

        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.prank(account);
            linkToken.transfer(PLAYER, STARTING_PLAYER_BALANCE);
        }
    }

    function testCreateSubscriptionUsingConfig() public {
        //arrange
        CreateSubscription createSubscription = new CreateSubscription(helperConfig);
        //act
        (uint256 returnedSubId, address returnedvrfCoordinator) = createSubscription.CreateSubscriptionUsingConfig();

        //assert
        assertEq(returnedvrfCoordinator, vrfCoordinator, "incorrect vrfcoordinator address");
        assertGt(returnedSubId, 0, "subscription id shoudl be greater than zero");

        subId = returnedSubId;
    }
}
