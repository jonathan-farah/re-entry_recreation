// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/vulnerable_contract.sol";
import "../src/Attacker.sol";

contract ReentrancyTest is Test {
   VulnerableContract vault;
    Attackers attacker;

    // Setup function that runs before each test
    function setUp() public {
        vault = new VulnerableContract();
        attacker = new Attackers(address(vault));

        // Fund the vault with 10 ether
        vm.deal(address(this), 10 ether);
        vault.deposit{value: 10 ether}();

        // Fund the attacker with 1 ether
        vm.deal(address(attacker), 1 ether);
    }

    // Test to simulate the reentrancy attack
    function testReentrancyAttack() public {
        // Starting the attack
        console.log("Starting the attack...");
        vm.startPrank(address(attacker));
        attacker.attack{value: 1 ether}();
        vm.stopPrank();

        // Final assertions
        console.log("Attacker's balance after the attack: %s ether", address(attacker).balance);
        console.log("Vulnerable contract's balance after the attack: %s ether", address(vault).balance);

        // Assert that the attacker drained the vulnerable contract
        assertEq(address(attacker).balance, 11 ether); // Attacker should have drained the vault (10 ether + 1 ether)
        assertEq(address(vault).balance, 0 ether);     // Vault balance should be 0
    }
}