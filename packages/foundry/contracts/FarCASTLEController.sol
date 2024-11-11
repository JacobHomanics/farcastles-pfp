//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./FarCASTLE.sol";
import "./SouthNFTs.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract FarCASTLEController is AccessControl {
    error Meep1();

    FarCASTLE s_castle;
    SouthNFTs s_opposingTroops;

    uint256 public s_costPerAttack;

    constructor(uint256 costPerAttack, address admin) {
        s_costPerAttack = costPerAttack;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function setTroops(address troops) external onlyRole(DEFAULT_ADMIN_ROLE) {
        s_opposingTroops = SouthNFTs(troops);
    }

    function setCastle(address castle) external onlyRole(DEFAULT_ADMIN_ROLE) {
        s_castle = FarCASTLE(castle);
    }

    function attack(uint256 amount) public payable {
        uint256 totalCost = amount * s_costPerAttack;
        if (msg.value < totalCost) {
            revert Meep1();
        }

        s_castle.receiveAttack(amount);
        s_opposingTroops.mint(msg.sender, amount);
    }

    function withdraw() external {}
}
