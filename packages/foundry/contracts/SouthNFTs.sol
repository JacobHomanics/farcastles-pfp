//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./FarcastleSideNFTs.sol";

contract SouthNFTs is FarcastleSideNFTs {
    constructor(
        address[] memory minters
    ) FarcastleSideNFTs(minters, "South", "SOUTH") {}
}
