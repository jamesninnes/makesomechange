// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/TimelockController.sol";

contract GovernanceTimeLock is TimelockController {

    constructor(
        uint256 minDelay, 
        address[] memory proposers, 
        address[] memory executors
    )
    TimelockController(minDelay, proposers, executors) {
        
    }
}