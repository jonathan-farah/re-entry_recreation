// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableContract {
    uint256 public balance;
    bool private _entered = false;

    // To disable reentrancy guard during testing, we can include a test-only modifier
    modifier noReentrancy() {
        require(!_entered, "ReentrancyGuard: reentrant call");
        _entered = true;
        _;
        _entered = false;
    }

    // For testing, we disable the reentrancy guard temporarily
    modifier disableReentrancyGuardForTest() {
        _;
    }

    // Deposit function to fund the contract
    function deposit() external payable {
        balance += msg.value;
    }

    // Withdraw function to withdraw funds
    function withdraw(uint256 amount) external noReentrancy {
        require(amount <= balance, "Insufficient balance");

        // Ensure enough gas is forwarded for the recipient contract
        (bool success, ) = msg.sender.call{value: amount, gas: 500000}("");
        require(success, "Transfer failed");

        balance -= amount;
    }

    // For testing purposes, we disable reentrancy guard temporarily
    function withdrawTest(uint256 amount) external disableReentrancyGuardForTest {
        require(amount <= balance, "Insufficient balance");

        // Transfer with enough gas for the attack to succeed
        (bool success, ) = msg.sender.call{value: amount, gas: 500000}("");
        require(success, "Transfer failed");

        balance -= amount;
    }
}
