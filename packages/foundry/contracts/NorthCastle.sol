//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../contracts/FarCASTLE.sol";

contract NorthCastle is FarCASTLE {
    constructor(
        uint256 startingHealth,
        address admin
    ) FarCASTLE(startingHealth, admin) {}
}