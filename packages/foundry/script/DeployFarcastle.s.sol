//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Farcastles.sol";
import "../contracts/SouthNFTs.sol";
import "./DeployHelpers.s.sol";
import "../contracts/FarCASTLE.sol";

contract DeployFarcastle is ScaffoldETHDeploy {
    string backgroundLayerName = "BACKGROUND";
    string armorLayerName = "ARMOR";
    string headLayerName = "HEAD";
    string weaponLayerName = "WEAPON";

    struct Traits {
        Armor ARMOR;
        Background BACKGROUND;
        Head HEAD;
        Weapon WEAPON;
    }

    struct Background {
        uint256 _id;
        string addr;
        uint256 builder_id;
        string date;
        string img_data;
        string name;
        uint16 rarity;
        string type2;
    }

    struct Armor {
        uint256 _id;
        string addr;
        uint256 builder_id;
        string date;
        string img_data;
        string name;
        uint16 rarity;
        string type2;
    }

    struct Head {
        uint256 _id;
        string addr;
        uint256 builder_id;
        string date;
        string img_data;
        string name;
        uint16 rarity;
        string type2;
    }

    struct Weapon {
        uint256 _id;
        string addr;
        uint256 builder_id;
        string date;
        string img_data;
        string name;
        uint16 rarity;
        string type2;
    }

    function getTraits2() internal view returns (Traits[] memory traits) {
        string memory root = vm.projectRoot();

        string memory path = string.concat(root, "/script/1337.json");
        string memory json = vm.readFile(path);
        bytes memory data = vm.parseJson(json);

        traits = abi.decode(data, (Traits[]));
    }

    // use `deployer` from `ScaffoldETHDeploy`
    function run() external //ScaffoldEthDeployerRunner
    {
        Traits[] memory allTraits = getTraits2();

        uint16[] memory backgroundRarities = new uint16[](allTraits.length);
        SouthNFTs.Payload[] memory backgroundPayloads = new SouthNFTs.Payload[](
            allTraits.length
        );

        for (uint256 i = 0; i < allTraits.length; i++) {
            backgroundRarities[i] = allTraits[i].BACKGROUND.rarity;
            backgroundPayloads[i] = SouthNFTs.Payload(
                allTraits[i].BACKGROUND.name,
                bytes(allTraits[i].BACKGROUND.img_data)
            );
        }

        uint256 batchAmount = 1;

        SouthNFTs.Payload[][]
            memory __backgroundPayloads = new SouthNFTs.Payload[][](
                allTraits.length
            );
        uint16[][] memory __backgroundRarities = new uint16[][](
            allTraits.length
        );

        for (uint256 j = 0; j < backgroundPayloads.length; j += batchAmount) {
            SouthNFTs.Payload[]
                memory _backgroundPayloads = new SouthNFTs.Payload[](
                    batchAmount
                );
            uint16[] memory _backgroundRarities = new uint16[](batchAmount);

            for (uint256 i = 0; i < batchAmount; i++) {
                _backgroundPayloads[i] = backgroundPayloads[i];
                _backgroundRarities[i] = backgroundRarities[i];
            }

            __backgroundPayloads[j] = _backgroundPayloads;
            __backgroundRarities[j] = _backgroundRarities;
            // }
        }

        startBroadcast();
        SouthNFTs farcastle2 = new SouthNFTs("Test", "TEST");
        stopBroadcast();

        for (uint256 j = 0; j < __backgroundPayloads.length; j++) {
            console.log(j);
            vm.startBroadcast();

            // (bool success, bytes memory returnData) = address(farcastle2).call{
            //     gas: 3_000_000_000_000_000_000_000_000_000_000_000_000
            // }(
            //     abi.encodeWithSelector(
            //         farcastle2.addTraits.selector,
            //         0,
            //         __backgroundPayloads[j],
            //         __backgroundRarities[j]
            //     )
            // );

            farcastle2.addTraits{
                gas: 3_000_000_000_000_000_000_000_000_000_000_000_000_000_000
            }(0, __backgroundPayloads[j], __backgroundRarities[j]);
            vm.stopBroadcast();
        }
    }

    function substring(
        string memory str,
        uint256 startIndex,
        uint256 endIndex
    ) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        require(endIndex >= startIndex, "Invalid indexes");
        require(endIndex < strBytes.length, "End index out of range");

        bytes memory result = new bytes(endIndex - startIndex + 1);
        for (uint256 i = startIndex; i <= endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }

        return string(result);
    }
}
