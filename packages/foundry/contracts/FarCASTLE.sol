//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract FarCASTLE is AccessControl {
    error Meep2();

    uint256 public s_currentHealth;

    constructor(uint256 startingHealth, address admin) {
        s_currentHealth = startingHealth;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function receiveAttack(uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE) {
        if (s_currentHealth <= 0) {
            revert Meep2();
        }

        s_currentHealth -= amount;
    }

    function withdraw() external {}
}
