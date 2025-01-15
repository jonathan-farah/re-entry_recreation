# renetry_recreation
The hack demonstrated here exploits a reentrancy vulnerability in the vulnerability contract. It was chosen to be my hack because Re-entry attacks highlight the importance of secure coding practices, including implementing reentrancy guards, avoiding external calls in critical functions, and updating contract states before performing any interactions with external parties, it is a well-known attack vector that has historically resulted in significant financial losses in smart contracts.

The withdrawTest function in the VulnerableContract transfers funds to the caller (msg.sender) using call.  However, it fails at updating its balance before sending, this allows the attacker to repeatedly call back into the contract and withdraw funds in a loop, draining its balance. This vulnerability was explicitly left unguarded in the withdrawTest function for testing purposes to recreate the exploit scenario.

how to create work
  1.deploys attack and vulnerability contract
  
  2.attacker deposits a small amount of Ether
  
  3.then the attack function,which calls withdrawTest to withdraw deposited funds
  
  4. The receive fallback function in the attacker contract is then triggered, allowing it to recursively call withdrawTest again before the vulnerable contract updates its balance.
     
  5.This recursive process continues until the gas limit is reached or the contract’s balance is fully drained

  6.the test simulates the real-world conditions of a reentrancy attack, demonstrating the exploit in action
