//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./SouthNFTs.sol";

contract FarCASTLE {
  error Meep1();
  error Meep2();

  SouthNFTs s_troops;

  uint256 public s_currentHealth;
  uint256 public s_costPerAttack;

  constructor(uint256 startingHealth, uint256 costPerAttack, address troops) {
    s_currentHealth = startingHealth;
    s_costPerAttack = costPerAttack;
    s_troops = SouthNFTs(troops);
  }

  function receiveAttack(
    uint256 amount
  ) public payable {
    uint256 totalCost = amount * s_costPerAttack;
    if (msg.value < totalCost) {
      revert Meep1();
    }

    if (s_currentHealth <= 0) {
      revert Meep2();
    }

    s_currentHealth--;

    s_troops.mint(msg.sender, amount);
  }

  function withdraw() external { }
}
