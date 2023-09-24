// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import { Test } from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployer;
    UpgradeBox upgrader;
    address user = makeAddr("user");

    BoxV1 box;
    BoxV2 box2;
    address proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        box = new BoxV1();
        box2 = new BoxV2();

        proxy = deployer.run();
    }

    function testProxyStartsAsBoxV1() external {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    function testUpgrade() external {
        BoxV1(proxy).upgradeTo(address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV1(proxy).getVersion());

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }
}