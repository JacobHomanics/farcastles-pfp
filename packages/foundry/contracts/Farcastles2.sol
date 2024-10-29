//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../lib/ERC721A/contracts/ERC721A.sol";
import "../lib/solady/src/utils/Base64.sol";
import "./ImageLibrary.sol";
import "../lib/solady/src/utils/LibString.sol";

contract Farcastles2 is ERC721A {
    // ********************************
    // STRUCTS
    // ********************************
    struct Trait {
        bytes image;
        string name;
    }

    struct Knight {
        uint256 background;
        uint256 armor;
        uint256 weapon;
        uint256 head;
    }

    struct Payload {
        string name;
        bytes image;
    }

    // ********************************
    // STATE VARIABLES
    // ********************************
    mapping(uint256 => mapping(uint256 index => Trait)) public s_traits;
    mapping(uint256 => uint256) public s_traitCounts;

    // uint256 public s_traitCount;
    // uint16[] public s_traitRarities;
    mapping(uint256 => uint256) public _combo;
    mapping(uint256 => uint256) public _registry;
    mapping(uint256 layer => uint256) public s_maxBoundRarity;

    // ********************************
    // CONSTRUCTOR
    // ********************************
    constructor(
        string memory name,
        string memory symbol
    ) ERC721A(name, symbol) {}

    // ********************************
    // PUBLIC WRITE FUNCTIONS
    // ********************************

    function mint(address to, uint256 amount) public {
        uint256 minted = _totalMinted();
        _setTokenTraits(minted, amount);
        _safeMint(to, amount, "");
    }

    function addTrait(
        uint256 layer,
        Payload calldata payload,
        uint16 rarity
    ) public {
        _setTrait(s_traitCounts[layer], layer, payload, rarity);
        unchecked {
            s_traitCounts[layer]++;
        }
    }

    // ********************************
    // INTERNAL WRITE FUNCTIONS
    // ********************************
    function _setTrait(
        uint256 traitIndex,
        uint256 layer,
        Payload calldata payload,
        uint16 rarity
    ) internal {
        Trait storage trait = s_traits[layer][traitIndex];
        trait.image = payload.image;
        trait.name = payload.name;
        s_traitRarities[layer].push(rarity);
        s_maxBoundRarity[layer] += rarity;
    }

    function setTokenTraits(uint256 tokenID, uint256 amount) public {
        _setTokenTraits(tokenID, amount);
    }

    uint16[][4] public s_traitRarities;

    function _setTokenTraits(uint256 tokenID, uint256 amount) private {
        uint256 seed = getRandomSeed(tokenID);

        uint256 current = tokenID;
        uint256 combination;

        uint16[] memory backgroundRarities = s_traitRarities[0];
        uint16[] memory armorRarities = s_traitRarities[1];
        uint16[] memory weaponRarities = s_traitRarities[2];
        uint16[] memory headRarities = s_traitRarities[3];

        while (true) {
            combination = _getRandomTraitIndex(0, backgroundRarities, seed);
            combination |= (_getRandomTraitIndex(
                1,
                armorRarities,
                seed >> 16
            ) << 8);
            combination |= (_getRandomTraitIndex(
                2,
                weaponRarities,
                seed >> 32
            ) << 16);
            combination |= (_getRandomTraitIndex(3, headRarities, seed >> 48) <<
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

    //function getTokenTrait
    function _storeTraits(uint256 tokenId, uint256 traitCombination) internal {
        uint256 bucket = tokenId / 4;
        _registry[bucket] = _calculateSlotInBucket(
            tokenId,
            traitCombination,
            bucket
        );
    }

    function _calculateSlotInBucket(
        uint256 key,
        uint256 value,
        uint256 bucket
    ) internal view returns (uint256) {
        uint256 slot = key % 4;
        uint256 traitMask = not(0xFFFFFFFFFFFFFFFF << (64 * slot));

        return (_registry[bucket] & traitMask) | (value << (64 * slot));
    }

    function getTokenTraits(
        uint256 tokenId
    ) public view returns (Knight memory) {
        return _getTraits(tokenId);
    }

    // ********************************
    // INTERNAL READ FUNCTIONS
    // ********************************
    function _getTraits(
        uint256 tokenId
    ) internal view returns (Knight memory knight) {
        uint256 bucket = tokenId / 4;
        uint256 slot = tokenId % 4;
        uint256 mask = 0xFFFFFFFFFFFFFFFF << (64 * slot);
        uint256 value = (_registry[bucket] & mask) >> (64 * slot);
        mask = 0xFF;

        knight.background = value & mask;
        value >>= 8;
        knight.armor = value & mask;
        value >>= 8;
        knight.weapon = value & mask;
        value >>= 8;
        knight.head = value & mask;
    }

    // ********************************
    // PUBLIC READ FUNCTIONS
    // ********************************
    function getTrait(
        uint256 layer,
        uint256 traitIndex
    ) public view returns (Trait memory) {
        return s_traits[layer][traitIndex];
    }

    function getSeedModulus(
        uint256 seed,
        uint256 modulus
    ) public pure returns (uint256) {
        return seed % modulus;
    }

    function getRandomTraitIndex(
        uint8 layer,
        uint256 tokenId
    ) public view returns (uint256) {
        uint256 seed = getRandomSeed(tokenId);

        return _getRandomTraitIndex(layer, s_traitRarities[layer], seed);
    }

    function getRandomSeed(uint256 id) public view returns (uint256 seed) {
        seed = uint256(
            keccak256(abi.encodePacked(block.prevrandao, id, address(this)))
        );
    }

    function _getRandomTraitIndex(
        uint8 layer,
        uint16[] memory rarities,
        uint256 seed
    ) public view returns (uint256 index) {
        uint256 rand = seed % s_maxBoundRarity[layer];
        uint256 lowerBound; // starts at 0
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

    function _getTraitAttributes(
        Knight memory knight
    ) internal view returns (string memory trait) {
        return
            string.concat(
                _getTraitMetadata(
                    "BACKGROUND",
                    s_traits[0][knight.background].name,
                    false
                ),
                ",",
                _getTraitMetadata(
                    "ARMOR",
                    s_traits[1][knight.armor].name,
                    false
                ),
                ",",
                _getTraitMetadata(
                    "WEAPON",
                    s_traits[2][knight.weapon].name,
                    false
                ),
                ",",
                _getTraitMetadata("HEAD", s_traits[3][knight.head].name, false)
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

    // ********************************
    // EXTERNAL READ FUNCTIONS
    // ********************************

    function tokenURI(
        uint256 tokenID
    ) public view override returns (string memory) {
        Knight memory traits = _getTraits(tokenID);
        bytes memory json = abi.encodePacked(
            '{"name": "South #',
            LibString.toString(tokenID),
            '", "description":"',
            "South Castle is the best!",
            '","image":"data:image/svg+xml;base64,',
            _getTraitImage(traits),
            '",',
            '"attributes": [',
            _getTraitAttributes(traits),
            "]}"
        );

        return string(abi.encodePacked("data:application/json,", json));
    }

    function _getTraitImage(
        Knight memory knight
    ) internal view returns (string memory image) {
        return
            Base64.encode(
                abi.encodePacked(
                    '<svg width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg">',
                    "<style>svg{background-color:transparent;background-image:",
                    _getTraitImageData(s_traits[3][knight.head].image),
                    ",",
                    _getTraitImageData(s_traits[2][knight.weapon].image),
                    ",",
                    _getTraitImageData(s_traits[1][knight.armor].image),
                    ",",
                    _getTraitImageData(s_traits[0][knight.background].image),
                    ";background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
                )
            );
    }

    function _getTraitImageData(
        bytes memory image
    ) private pure returns (string memory) {
        return
            string(abi.encodePacked("url(data:image/png;base64,", image, ")"));
    }

    function not(uint256 val) internal pure returns (uint256 notval) {
        assembly ("memory-safe") {
            notval := not(val)
        }
    }
}
