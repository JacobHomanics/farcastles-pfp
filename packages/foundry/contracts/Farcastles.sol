//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import {ScaffoldERC721A} from "./ScaffoldERC721A.sol";
import "forge-std/Test.sol";
import {ItemStorage} from "./ItemStorage.sol";
import {OnchainNft} from "./OnchainNft.sol";
import "../lib/solady/src/utils/LibString.sol";
import "../lib/solady/src/utils/Base64.sol";

import "@openzeppelin/contracts/utils/Strings.sol";
import {SSTORE2} from "../lib/sstore2/contracts/SSTORE2.sol";

contract Farcastles is ScaffoldERC721A {
    mapping(uint256 => uint256) private _traitCounts;
    mapping(uint256 => mapping(uint256 => Trait)) private _traits;
    mapping(uint256 => uint256) private _combo;
    struct Trait {
        // address image;
        bytes image;
        string name;
    }

    struct Payload {
        string name;
        bytes image;
    }

    struct Knight {
        uint256 BACKGROUND;
        uint256 ARMOR;
        uint256 HEAD;
        uint256 WEAPON;
    }

    uint16[][6] private _traitRarities;

    constructor(
        ScaffoldERC721AParameters memory params
    ) ScaffoldERC721A(params) {}

    function addTrait(
        uint8 layer,
        Payload calldata payload,
        uint16 rarity //onlyOwner
    ) public {
        uint256 traitIndex = _traitCounts[layer];

        _addTrait(traitIndex, layer, payload, rarity);

        unchecked {
            ++traitIndex;
        }
    }

    function _addTrait(
        uint256 traitIndex,
        uint8 layer,
        Payload calldata payload,
        uint16 rarity
    ) internal {
        Trait storage trait = _traits[layer][traitIndex];
        trait.image = payload.image;
        // trait.image = SSTORE2.write(payload.image);
        trait.name = payload.name;
        _traitRarities[layer].push(rarity);
    }

    function addTraits(
        uint8 layer,
        Payload[] calldata payload,
        uint16[] calldata traitRarities
    ) public onlyOwner {
        if (payload.length != traitRarities.length) revert();
        uint256 traitIndex = _traitCounts[layer];
        unchecked {
            _traitCounts[layer] += payload.length;
        }

        for (uint256 i; i < payload.length; ) {
            _addTrait(traitIndex, layer, payload[i], traitRarities[i]);

            unchecked {
                ++i;
                ++traitIndex;
            }
        }
    }

    function _base64EncodeJSON(
        string memory json
    ) internal pure returns (string memory) {
        return Base64.encode(bytes(json));
    }

    function _getTraitImage(
        Knight memory knight
    ) internal view returns (string memory image) {
        return
            Base64.encode(
                abi.encodePacked(
                    '<svg width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg">',
                    "<style>svg{background-color:transparent;background-image:",
                    _getTraitImageData(_traits[3][knight.WEAPON].image),
                    ",",
                    _getTraitImageData(_traits[2][knight.HEAD].image),
                    ",",
                    _getTraitImageData(_traits[1][knight.ARMOR].image),
                    ",",
                    _getTraitImageData(_traits[0][knight.BACKGROUND].image),
                    ";background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
                )
            );
    }

    function getTraitImageData(
        bytes memory image
    ) external view returns (string memory) {
        return _getTraitImageData(image);
    }

    /**
     * @notice Get trait image at address
     */
    function _getTraitImageData(
        bytes memory image
    )
        private
        view
        returns (
            // address image
            string memory
        )
    {
        return
            string(
                abi.encodePacked(
                    "url(data:image/png;base64,",
                    image,
                    // Base64.encode(image),
                    // Base64.encode(SSTORE2.read(image)),
                    ")"
                )
            );
    }

    function _getTraitAttributes(
        Knight memory knight
    ) internal view returns (string memory trait) {
        return
            string.concat(
                _getTraitMetadata(
                    "BACKGROUND",
                    _traits[0][knight.BACKGROUND].name,
                    false
                ),
                ",",
                _getTraitMetadata(
                    "ARMOR",
                    _traits[1][knight.ARMOR].name,
                    false
                ),
                _getTraitMetadata("HEAD", _traits[2][knight.HEAD].name, true),
                _getTraitMetadata(
                    "WEAPON",
                    _traits[3][knight.WEAPON].name,
                    true
                )
            );
    }

    function _getTraitMetadata(
        string memory key,
        string memory value,
        bool withComma
    ) internal pure returns (string memory trait) {
        if (
            keccak256(abi.encodePacked(value)) ==
            keccak256(abi.encodePacked("none"))
        ) {
            return "";
        }
        if (withComma) {
            return
                string.concat(
                    ',{"trait_type":"',
                    key,
                    '","value": "',
                    value,
                    '"}'
                );
        }
        return
            string.concat('{"trait_type":"', key, '","value": "', value, '"}');
    }

    error Farcastles__InvalidToken();

    function getTrait(
        uint256 layer,
        uint256 index
    ) external view returns (Trait memory trait) {
        return _traits[layer][index];
    }

    function getTraits(
        uint256 tokenID
    ) external view returns (Knight memory knight) {
        return _getTraits(tokenID);
    }

    function getTraitAttributes(
        uint256 tokenID
    ) external view returns (string memory trait) {
        return _getTraitAttributes(_getTraits(tokenID));
    }

    function getTraitImage(
        uint256 tokenID
    ) external view returns (string memory image) {
        return _getTraitImage(_getTraits(tokenID));
    }

    function tokenURI(
        uint256 tokenID
    ) public view virtual override returns (string memory metadata) {
        if (!_exists(tokenID)) revert Farcastles__InvalidToken(); //InvalidToken();

        Knight memory brian = _getTraits(tokenID);
        bytes memory json = abi.encodePacked(
            '{"name": "1337 Brian #',
            LibString.toString(tokenID),
            '", "description":"',
            "1337 Brians is a collection of 8,453 pixel art bald brians, deployed fully onchain with a public domain license. Community crafted for Onchain Summer, these based brians are the latest from the 1337 hackers that brought you 1337 Skulls and more. Stay based and get 1337 pilled at 1337skulls.xyz.",
            '","image":"data:image/svg+xml;base64,',
            _getTraitImage(brian),
            '",',
            '"attributes": [',
            _getTraitAttributes(brian),
            "]}"
        );

        return string(abi.encodePacked("data:application/json,", json));
    }

    mapping(uint256 => uint256) private _registry;

    function _getTraits(
        uint256 tokenId
    ) internal view returns (Knight memory knight) {
        uint256 tokenTraitBucket = tokenId / 4;
        uint256 tokenTraitSlot = tokenId % 4;
        uint256 traitMask = 0xFFFFFFFFFFFFFFFF << (64 * tokenTraitSlot);
        uint256 traitCombination = (_registry[tokenTraitBucket] & traitMask) >>
            (64 * tokenTraitSlot);
        traitMask = 0xFF;

        knight.BACKGROUND = traitCombination & traitMask;
        traitCombination >>= 8;
        knight.ARMOR = traitCombination & traitMask;
        traitCombination >>= 8;
        knight.HEAD = traitCombination & traitMask;
        traitCombination >>= 8;
        knight.WEAPON = traitCombination & traitMask;
    }

    function _mint(uint256 amount, address to) internal {
        uint256 minted = _totalMinted();
        _setTraitsCombination(minted, amount);

        super._mint(to, amount);
    }

    function _setTraitsCombination(uint256 tokenID, uint256 amount) private {
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(block.prevrandao, tokenID, address(this))
            )
        );

        uint256 current = tokenID;
        uint256 combination;
        uint16[] memory backgroundRarities = _traitRarities[0];
        uint16[] memory armorRarities = _traitRarities[1];
        uint16[] memory headRarities = _traitRarities[2];
        uint16[] memory weaponRarities = _traitRarities[3];

        while (true) {
            combination = _getRandomTraitIndex(backgroundRarities, seed);
            combination |= (_getRandomTraitIndex(armorRarities, seed >> 16) <<
                8);
            combination |= (_getRandomTraitIndex(headRarities, seed >> 32) <<
                16);
            combination |= (_getRandomTraitIndex(weaponRarities, seed >> 48) <<
                24);

            if (_combo[combination] == 0) {
                _combo[combination] = 1;
                _storeTraits(current, combination);

                unchecked {
                    ++current;
                    if (current > (tokenID + amount)) break;
                }
            }
            seed = uint256(keccak256(abi.encode(seed)));
        }
    }

    function _getRandomTraitIndex(
        uint16[] memory rarities,
        uint256 seed
    ) private pure returns (uint256 index) {
        uint256 rand = seed % 10000;
        uint256 lowerBound;
        uint256 upperBound;
        uint256 percentage;

        for (uint256 i; i < rarities.length; ) {
            percentage = rarities[i];
            upperBound = lowerBound + percentage;

            if (rand >= lowerBound && rand < upperBound) {
                return i;
            }

            unchecked {
                lowerBound = upperBound;
                ++i;
            }
        }
        revert();
    }

    function _storeTraits(uint256 tokenId, uint256 traitCombination) internal {
        uint256 tokenTraitBucket = tokenId / 4;
        uint256 tokenTraitSlot = tokenId % 4;
        uint256 traitMask = not(0xFFFFFFFFFFFFFFFF << (64 * tokenTraitSlot));
        _registry[tokenTraitBucket] =
            (_registry[tokenTraitBucket] & traitMask) |
            (traitCombination << (64 * tokenTraitSlot));
    }

    function not(uint256 val) internal pure returns (uint256 notval) {
        assembly ("memory-safe") {
            notval := not(val)
        }
    }

    // function tokenURI(
    //     uint256 tokenId
    // ) public view override returns (string memory) {
    //     require(_exists(tokenId), "Token does not exist");

    //     // Get traits for the tokenId
    //     Trait memory background = backgroundTraits[tokenId];
    //     Trait memory head = headTraits[tokenId];

    //     // Combine the base64-encoded images
    //     string memory combinedBase64Image = _combineBase64Images(
    //         background.base64_img_data,
    //         head.base64_img_data
    //     );

    //     // Construct the JSON metadata
    //     string memory json = string(
    //         abi.encodePacked(
    //             '{"name": "NFT #',
    //             Strings.toString(tokenId),
    //             '",',
    //             '"description": "An NFT with combined base64-encoded traits",',
    //             '"img_data": "',
    //             combinedBase64Image,
    //             '",',
    //             '"attributes": [',
    //             '{ "trait_type": "BACKGROUND", "value": "',
    //             background.name,
    //             '" },',
    //             '{ "trait_type": "HEAD", "value": "',
    //             head.name,
    //             '" }',
    //             "]}"
    //         )
    //     );

    //     // Encode the JSON metadata as base64
    //     string memory base64Json = _base64EncodeJSON(json);

    //     // Return the data URI format
    //     return
    //         string(
    //             abi.encodePacked("data:application/json;base64,", base64Json)
    //         );
    // }

    // function setTraits(
    //     uint256 tokenId,
    //     string memory backgroundId,
    //     string memory backgroundBase64ImgData,
    //     string memory backgroundName,
    //     string memory headId,
    //     string memory headBase64ImgData,
    //     string memory headName
    // ) public {
    //     backgroundTraits[tokenId] = Trait(
    //         backgroundId,
    //         backgroundBase64ImgData,
    //         backgroundName,
    //         0,
    //         "BACKGROUND"
    //     );
    //     headTraits[tokenId] = Trait(
    //         headId,
    //         headBase64ImgData,
    //         headName,
    //         0,
    //         "HEAD"
    //     );
    // }
}
