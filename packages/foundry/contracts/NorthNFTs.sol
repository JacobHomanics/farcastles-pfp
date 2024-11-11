//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "./FarcastleSideNFTs.sol";

contract NorthNFTs is FarcastleSideNFTs {
    constructor(
        address[] memory minters
    ) FarcastleSideNFTs(minters, "North", "NORTH") {}
}
