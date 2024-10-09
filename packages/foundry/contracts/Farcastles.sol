//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {ScaffoldERC721A} from "./ScaffoldERC721A.sol";
import "forge-std/Test.sol";

contract Farcastles is ScaffoldERC721A {
    error PizzaPeople__AddressNotZero();
    error PizzaPeople__NotOwnerOfToken();

    constructor(
        ScaffoldERC721AParameters memory params,
        address[] memory initialMintRecipients
    ) ScaffoldERC721A(params) {}
}
