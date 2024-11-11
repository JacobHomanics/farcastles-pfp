//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./FarCASTLEController.sol";

contract NorthCastleController is FarCASTLEController {
    constructor(
        uint256 costPerAttack,
        address admin
    ) FarCASTLEController(costPerAttack, admin) {}
}