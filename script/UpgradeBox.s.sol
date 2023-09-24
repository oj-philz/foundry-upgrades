// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {

    function run() external returns (address) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        BoxV2 box = new BoxV2();
        address proxy = upgradeBox(mostRecentlyDeployed, address(box));
        vm.stopBroadcast();

        return address(proxy);
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);
        proxy.upgradeTo(newBox);
        vm.stopBroadcast();

        return address(proxy);
    }
}