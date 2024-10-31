/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  31337: {
    SouthNFTs: {
      address: "0x0896efb3b8d29e922abbc26c3d51cbc7df106082",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "name",
              type: "string",
              internalType: "string",
            },
            {
              name: "symbol",
              type: "string",
              internalType: "string",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "_combo",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "_getRandomTraitIndex",
          inputs: [
            {
              name: "layer",
              type: "uint8",
              internalType: "uint8",
            },
            {
              name: "rarities",
              type: "uint16[]",
              internalType: "uint16[]",
            },
            {
              name: "seed",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "index",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "_registry",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "addTrait",
          inputs: [
            {
              name: "layer",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "payload",
              type: "tuple",
              internalType: "struct SouthNFTs.Payload",
              components: [
                {
                  name: "name",
                  type: "string",
                  internalType: "string",
                },
                {
                  name: "image",
                  type: "bytes",
                  internalType: "bytes",
                },
              ],
            },
            {
              name: "rarity",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "addTraits",
          inputs: [
            {
              name: "layer",
              type: "uint8",
              internalType: "uint8",
            },
            {
              name: "payload",
              type: "tuple[]",
              internalType: "struct SouthNFTs.Payload[]",
              components: [
                {
                  name: "name",
                  type: "string",
                  internalType: "string",
                },
                {
                  name: "image",
                  type: "bytes",
                  internalType: "bytes",
                },
              ],
            },
            {
              name: "traitRarities",
              type: "uint16[]",
              internalType: "uint16[]",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "approve",
          inputs: [
            {
              name: "to",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "balanceOf",
          inputs: [
            {
              name: "owner",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getApproved",
          inputs: [
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getTokenTraits",
          inputs: [
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "tuple",
              internalType: "struct SouthNFTs.Knight",
              components: [
                {
                  name: "background",
                  type: "uint256",
                  internalType: "uint256",
                },
                {
                  name: "armor",
                  type: "uint256",
                  internalType: "uint256",
                },
                {
                  name: "head",
                  type: "uint256",
                  internalType: "uint256",
                },
                {
                  name: "weapon",
                  type: "uint256",
                  internalType: "uint256",
                },
              ],
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getTrait",
          inputs: [
            {
              name: "layer",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "traitIndex",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "tuple",
              internalType: "struct SouthNFTs.Trait",
              components: [
                {
                  name: "image",
                  type: "bytes",
                  internalType: "bytes",
                },
                {
                  name: "name",
                  type: "string",
                  internalType: "string",
                },
              ],
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "isApprovedForAll",
          inputs: [
            {
              name: "owner",
              type: "address",
              internalType: "address",
            },
            {
              name: "operator",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "mint",
          inputs: [
            {
              name: "to",
              type: "address",
              internalType: "address",
            },
            {
              name: "amount",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "name",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "string",
              internalType: "string",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "ownerOf",
          inputs: [
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "s_maxBoundRarity",
          inputs: [
            {
              name: "layer",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "s_traitCounts",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "s_traitRarities",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "s_traits",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "index",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "image",
              type: "bytes",
              internalType: "bytes",
            },
            {
              name: "name",
              type: "string",
              internalType: "string",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "safeTransferFrom",
          inputs: [
            {
              name: "from",
              type: "address",
              internalType: "address",
            },
            {
              name: "to",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "safeTransferFrom",
          inputs: [
            {
              name: "from",
              type: "address",
              internalType: "address",
            },
            {
              name: "to",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "_data",
              type: "bytes",
              internalType: "bytes",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "setApprovalForAll",
          inputs: [
            {
              name: "operator",
              type: "address",
              internalType: "address",
            },
            {
              name: "approved",
              type: "bool",
              internalType: "bool",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "setTokenTraits",
          inputs: [
            {
              name: "tokenID",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "amount",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "supportsInterface",
          inputs: [
            {
              name: "interfaceId",
              type: "bytes4",
              internalType: "bytes4",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "symbol",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "string",
              internalType: "string",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "tokenURI",
          inputs: [
            {
              name: "tokenID",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "string",
              internalType: "string",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "totalSupply",
          inputs: [],
          outputs: [
            {
              name: "result",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "transferFrom",
          inputs: [
            {
              name: "from",
              type: "address",
              internalType: "address",
            },
            {
              name: "to",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "event",
          name: "Approval",
          inputs: [
            {
              name: "owner",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "approved",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              indexed: true,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "ApprovalForAll",
          inputs: [
            {
              name: "owner",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "operator",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "approved",
              type: "bool",
              indexed: false,
              internalType: "bool",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "ConsecutiveTransfer",
          inputs: [
            {
              name: "fromTokenId",
              type: "uint256",
              indexed: true,
              internalType: "uint256",
            },
            {
              name: "toTokenId",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "from",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "to",
              type: "address",
              indexed: true,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "Transfer",
          inputs: [
            {
              name: "from",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "to",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              indexed: true,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "ApprovalCallerNotOwnerNorApproved",
          inputs: [],
        },
        {
          type: "error",
          name: "ApprovalQueryForNonexistentToken",
          inputs: [],
        },
        {
          type: "error",
          name: "BalanceQueryForZeroAddress",
          inputs: [],
        },
        {
          type: "error",
          name: "Farcastle__SEED_SUCKED",
          inputs: [],
        },
        {
          type: "error",
          name: "MintERC2309QuantityExceedsLimit",
          inputs: [],
        },
        {
          type: "error",
          name: "MintToZeroAddress",
          inputs: [],
        },
        {
          type: "error",
          name: "MintZeroQuantity",
          inputs: [],
        },
        {
          type: "error",
          name: "NotCompatibleWithSpotMints",
          inputs: [],
        },
        {
          type: "error",
          name: "OwnerQueryForNonexistentToken",
          inputs: [],
        },
        {
          type: "error",
          name: "OwnershipNotInitializedForExtraData",
          inputs: [],
        },
        {
          type: "error",
          name: "SequentialMintExceedsLimit",
          inputs: [],
        },
        {
          type: "error",
          name: "SequentialUpToTooSmall",
          inputs: [],
        },
        {
          type: "error",
          name: "SpotMintTokenIdTooSmall",
          inputs: [],
        },
        {
          type: "error",
          name: "TokenAlreadyExists",
          inputs: [],
        },
        {
          type: "error",
          name: "TransferCallerNotOwnerNorApproved",
          inputs: [],
        },
        {
          type: "error",
          name: "TransferFromIncorrectOwner",
          inputs: [],
        },
        {
          type: "error",
          name: "TransferToNonERC721ReceiverImplementer",
          inputs: [],
        },
        {
          type: "error",
          name: "TransferToZeroAddress",
          inputs: [],
        },
        {
          type: "error",
          name: "URIQueryForNonexistentToken",
          inputs: [],
        },
      ],
      inheritedFunctions: {
        approve: "lib/ERC721A/contracts/ERC721A.sol",
        balanceOf: "lib/ERC721A/contracts/ERC721A.sol",
        getApproved: "lib/ERC721A/contracts/ERC721A.sol",
        isApprovedForAll: "lib/ERC721A/contracts/ERC721A.sol",
        name: "lib/ERC721A/contracts/ERC721A.sol",
        ownerOf: "lib/ERC721A/contracts/ERC721A.sol",
        safeTransferFrom: "lib/ERC721A/contracts/ERC721A.sol",
        setApprovalForAll: "lib/ERC721A/contracts/ERC721A.sol",
        supportsInterface: "lib/ERC721A/contracts/ERC721A.sol",
        symbol: "lib/ERC721A/contracts/ERC721A.sol",
        tokenURI: "lib/ERC721A/contracts/ERC721A.sol",
        totalSupply: "lib/ERC721A/contracts/ERC721A.sol",
        transferFrom: "lib/ERC721A/contracts/ERC721A.sol",
      },
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
