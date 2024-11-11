//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Farcastles.sol";
import "../contracts/FarcastleSideNFTs.sol";
import "./DeployHelpers.s.sol";
import "../contracts/FarCASTLE.sol";

contract DeployFarcastle is ScaffoldETHDeploy {
    string backgroundLayerName = "BACKGROUND";
    string armorLayerName = "ARMOR";
    string headLayerName = "HEAD";
    string weaponLayerName = "WEAPON";

    struct Traits {
        Trait ARMOR;
        Trait BACKGROUND;
        Trait HEAD;
        Trait WEAPON;
    }

    struct Trait {
        uint256 _id;
        string addr;
        uint256 builder_id;
        string date;
        string img_data;
        string name;
        uint16 rarity;
        string type2;
    }

    // struct Background {
    //     uint256 _id;
    //     string addr;
    //     uint256 builder_id;
    //     string date;
    //     string img_data;
    //     string name;
    //     uint16 rarity;
    //     string type2;
    // }

    // struct Armor {
    //     uint256 _id;
    //     string addr;
    //     uint256 builder_id;
    //     string date;
    //     string img_data;
    //     string name;
    //     uint16 rarity;
    //     string type2;
    // }

    // struct Head {
    //     uint256 _id;
    //     string addr;
    //     uint256 builder_id;
    //     string date;
    //     string img_data;
    //     string name;
    //     uint16 rarity;
    //     string type2;
    // }

    // struct Weapon {
    //     uint256 _id;
    //     string addr;
    //     uint256 builder_id;
    //     string date;
    //     string img_data;
    //     string name;
    //     uint16 rarity;
    //     string type2;
    // }

    function getTraits2() internal view returns (Traits[] memory traits) {
        string memory root = vm.projectRoot();

        string memory path = string.concat(root, "/script/1337.json");
        string memory json = vm.readFile(path);
        bytes memory data = vm.parseJson(json);

        traits = abi.decode(data, (Traits[]));
    }

    // function getBackgrounds(
    //     Traits[] memory allTraits,
    //     uint256 index
    // ) public returns (uint16[] memory, FarcastleSideNFTs.Payload[] memory) {
    //     uint16[] memory rarities = new uint16[](allTraits.length);
    //     FarcastleSideNFTs.Payload[] memory payloads = new FarcastleSideNFTs.Payload[](
    //         allTraits.length
    //     );

    //     rarities[index] = allTraits[index].BACKGROUND.rarity;
    //     payloads[index] = FarcastleSideNFTs.Payload(
    //         allTraits[index].BACKGROUND.name,
    //         bytes(allTraits[index].BACKGROUND.img_data)
    //     );

    //     return (rarities, payloads);
    // }

    // function getArmor(
    //     Traits[] memory allTraits,
    //     uint256 index
    // ) public returns (uint16[] memory, FarcastleSideNFTs.Payload[] memory) {
    //     uint16[] memory rarities = new uint16[](allTraits.length);
    //     FarcastleSideNFTs.Payload[] memory payloads = new FarcastleSideNFTs.Payload[](
    //         allTraits.length
    //     );

    //     rarities[index] = allTraits[index].ARMOR.rarity;
    //     payloads[index] = FarcastleSideNFTs.Payload(
    //         allTraits[index].ARMOR.name,
    //         bytes(allTraits[index].ARMOR.img_data)
    //     );

    //     return (rarities, payloads);
    // }

    // function setupProp(Traits[] memory allTraits) public {
    //     for (uint256 i = 0; i < allTraits.length; i++) {
    //         (
    //             uint16[] backgroundRarities,
    //             FarcastleSideNFTs.Payload[] backgroundPayloads
    //         ) = getBackgrounds(allTraits, i);
    //     }

    //     for (uint256 i = 0; i < allTraits.length; i++) {
    //         (
    //             uint16[] backgroundRarities,
    //             FarcastleSideNFTs.Payload[] backgroundPayloads
    //         ) = getArmor(allTraits, i);
    //     }

    //     uint256 batchAmount = 100;

    //     for (uint256 i = 0; i < backgroundPayloads.length; i += batchAmount) {

    //     }

    //     FarcastleSideNFTs.Payload[][] memory __payloads = new FarcastleSideNFTs.Payload[][](
    //         allTraits.length
    //     );
    //     uint16[][] memory __rarities = new uint16[][](allTraits.length);

    //     for (uint256 j = 0; j < payloads.length; j += batchAmount) {
    //         FarcastleSideNFTs.Payload[] memory _payloads = new FarcastleSideNFTs.Payload[](
    //             batchAmount
    //         );
    //         uint16[] memory _rarities = new uint16[](batchAmount);

    //         for (uint256 i = 0; i < batchAmount; i++) {
    //             _payloads[i] = payloads[i];
    //             _rarities[i] = rarities[i];
    //         }

    //         __payloads[j] = _payloads;
    //         __rarities[j] = _rarities;
    //         // }
    //     }
    // }

    // FarcastleSideNFTs.Payload[][] payloadsBatches;
    // uint16[][] raritiesBatches;

    // function setMe(Traits[] memory allTraits) public {
    //     // uint16[][] memory raritiesBatches = new uint16[][](
    //     //     allTraits.length * 4
    //     // );

    //     uint256 batchAmount = 100;

    //     // for (
    //     //     uint256 batchIndex = 0;
    //     //     batchIndex < batchAmount;
    //     //     batchIndex += 4
    //     // ) {}

    //     // uint256 batchIndex = 0;

    //     // FarcastleSideNFTs.Payload[][]
    //     //     memory payloadsBatches = new FarcastleSideNFTs.Payload[][](batchAmount);

    //     // FarcastleSideNFTs.Payload[][]
    //     //     memory payloadsBatches = new FarcastleSideNFTs.Payload[][](
    //     //         (allTraits.length * batchAmount) / 4
    //     //     );

    //     for (
    //         uint256 traitIndex = 0;
    //         traitIndex < allTraits.length;
    //         traitIndex += batchAmount
    //     ) {
    //         FarcastleSideNFTs.Payload[] memory payloadBatches = new FarcastleSideNFTs.Payload[](
    //             batchAmount
    //         );

    //         uint16[] memory rarityBatches = new uint16[](batchAmount);

    //         for (
    //             uint256 batchIndex = 0;
    //             batchIndex < batchAmount;
    //             batchIndex += 4
    //         ) {
    //             FarcastleSideNFTs.Payload memory backgroundPayload = FarcastleSideNFTs.Payload(
    //                 allTraits[traitIndex].BACKGROUND.name,
    //                 bytes(allTraits[traitIndex].BACKGROUND.img_data)
    //             );
    //             FarcastleSideNFTs.Payload memory armorPayload = FarcastleSideNFTs.Payload(
    //                 allTraits[traitIndex + 1].ARMOR.name,
    //                 bytes(allTraits[traitIndex + 1].ARMOR.img_data)
    //             );
    //             FarcastleSideNFTs.Payload memory headPayload = FarcastleSideNFTs.Payload(
    //                 allTraits[traitIndex + 2].HEAD.name,
    //                 bytes(allTraits[traitIndex + 2].HEAD.img_data)
    //             );
    //             FarcastleSideNFTs.Payload memory weaponPayload = FarcastleSideNFTs.Payload(
    //                 allTraits[traitIndex + 3].WEAPON.name,
    //                 bytes(allTraits[traitIndex + 3].WEAPON.img_data)
    //             );

    //             payloadBatches[batchIndex] = backgroundPayload;
    //             payloadBatches[batchIndex + 1] = armorPayload;
    //             payloadBatches[batchIndex + 2] = headPayload;
    //             payloadBatches[batchIndex + 3] = weaponPayload;

    //             rarityBatches[batchIndex] = allTraits[traitIndex]
    //                 .BACKGROUND
    //                 .rarity;
    //             rarityBatches[batchIndex + 1] = allTraits[traitIndex]
    //                 .ARMOR
    //                 .rarity;
    //             rarityBatches[batchIndex + 2] = allTraits[traitIndex]
    //                 .HEAD
    //                 .rarity;
    //             rarityBatches[batchIndex + 3] = allTraits[traitIndex]
    //                 .WEAPON
    //                 .rarity;
    //         }

    //         payloadsBatches.push(payloadBatches);
    //         raritiesBatches.push(rarityBatches);
    //     }
    // }

    // uint256 traitIndex = 0;
    // for (
    //     uint256 batchIndex = 0;
    //     batchIndex < batchAmount;
    //     batchIndex += 4
    // ) {
    //     FarcastleSideNFTs.Payload memory backgroundPayload = FarcastleSideNFTs.Payload(
    //         allTraits[traitIndex].BACKGROUND.name,
    //         bytes(allTraits[traitIndex].BACKGROUND.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory armorPayload = FarcastleSideNFTs.Payload(
    //         allTraits[traitIndex + 1].ARMOR.name,
    //         bytes(allTraits[traitIndex + 1].ARMOR.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory headPayload = FarcastleSideNFTs.Payload(
    //         allTraits[traitIndex + 2].HEAD.name,
    //         bytes(allTraits[traitIndex + 2].HEAD.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory weaponPayload = FarcastleSideNFTs.Payload(
    //         allTraits[traitIndex + 3].WEAPON.name,
    //         bytes(allTraits[traitIndex + 3].WEAPON.img_data)
    //     );

    //     payloadBatches[batchIndex + 0] = backgroundPayload;
    //     payloadBatches[batchIndex + 1] = armorPayload;
    //     payloadBatches[batchIndex + 2] = headPayload;
    //     payloadBatches[batchIndex + 3] = weaponPayload;

    //     traitIndex += 4;
    // }

    // uint256 batchIndex = 0;

    // uint256 batchCount = 0;

    // for (uint256 i = 0; i < allTraits.length; i++) {
    //     FarcastleSideNFTs.Payload[] memory payloadBatches = new FarcastleSideNFTs.Payload[](
    //         batchAmount
    //     );

    //     FarcastleSideNFTs.Payload memory backgroundPayload = FarcastleSideNFTs.Payload(
    //         allTraits[i].BACKGROUND.name,
    //         bytes(allTraits[i].BACKGROUND.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory armorPayload = FarcastleSideNFTs.Payload(
    //         allTraits[i].ARMOR.name,
    //         bytes(allTraits[i].ARMOR.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory headPayload = FarcastleSideNFTs.Payload(
    //         allTraits[i].HEAD.name,
    //         bytes(allTraits[i].HEAD.img_data)
    //     );
    //     FarcastleSideNFTs.Payload memory weaponPayload = FarcastleSideNFTs.Payload(
    //         allTraits[i].WEAPON.name,
    //         bytes(allTraits[i].WEAPON.img_data)
    //     );

    //     payloadBatches[batchIndex + 0] = backgroundPayload;
    //     payloadBatches[batchIndex + 1] = armorPayload;
    //     payloadBatches[batchIndex + 2] = headPayload;
    //     payloadBatches[batchIndex + 3] = weaponPayload;

    //     batchIndex += 4;
    //     if (batchIndex >= batchAmount) {
    //         payloadsBatches[batchCount] = payloadBatches;
    //         batchCount++;
    //         batchIndex = 0;
    //     }
    // }

    // for (uint256 i = 0; i < batchAmount / 4; i++) {}

    // for (uint256 j = 0; j < allTraits.length; j += batchAmount) {
    //     payloadsBatches[j] = FarcastleSideNFTs.Payload(
    //         allTraits[j].BACKGROUND.name,
    //         allTraits[j].BACKGROUND.img_data
    //     );

    //     FarcastleSideNFTs.Payload[] memory payloadBatch = new FarcastleSideNFTs.Payload[](
    //         batchAmount
    //     );
    //     uint16[] memory raritiesBatch = new uint16[](batchAmount);

    //     for (uint256 i = 0; i < batchAmount; i++) {
    //         payloadBatch[i] = backgroundPayloads[i];
    //         _backgroundRarities[i] = backgroundRarities[i];
    //     }
    // }
    // }

    function yes1(
        Traits[] memory allTraits
    )
        public
        pure
        returns (uint16[][] memory, FarcastleSideNFTs.Payload[][] memory)
    {
        uint16[][] memory rarities = new uint16[][](4);
        FarcastleSideNFTs.Payload[][]
            memory payloads = new FarcastleSideNFTs.Payload[][](4);

        for (uint256 i = 0; i < 4; i++) {
            rarities[i] = new uint16[](allTraits.length);
            payloads[i] = new FarcastleSideNFTs.Payload[](allTraits.length);
        }

        for (uint256 i = 0; i < allTraits.length; i++) {
            rarities[0][i] = allTraits[i].BACKGROUND.rarity;
            payloads[0][i] = FarcastleSideNFTs.Payload(
                allTraits[i].BACKGROUND.name,
                bytes(allTraits[i].BACKGROUND.img_data)
            );
        }

        for (uint256 i = 0; i < allTraits.length; i++) {
            rarities[1][i] = allTraits[i].ARMOR.rarity;
            payloads[1][i] = FarcastleSideNFTs.Payload(
                allTraits[i].ARMOR.name,
                bytes(allTraits[i].ARMOR.img_data)
            );
        }

        for (uint256 i = 0; i < allTraits.length; i++) {
            rarities[2][i] = allTraits[i].HEAD.rarity;
            payloads[2][i] = FarcastleSideNFTs.Payload(
                allTraits[i].HEAD.name,
                bytes(allTraits[i].HEAD.img_data)
            );
        }

        for (uint256 i = 0; i < allTraits.length; i++) {
            rarities[3][i] = allTraits[i].WEAPON.rarity;
            payloads[3][i] = FarcastleSideNFTs.Payload(
                allTraits[i].WEAPON.name,
                bytes(allTraits[i].WEAPON.img_data)
            );
        }

        return (rarities, payloads);
    }

    function trimAllTraitsImage(
        Traits[] memory allTraits
    ) public pure returns (Traits[] memory) {
        for (uint256 i = 0; i < allTraits.length; i++) {
            allTraits[i].BACKGROUND.img_data = substring(
                allTraits[i].BACKGROUND.img_data,
                22,
                bytes(allTraits[i].BACKGROUND.img_data).length - 1
            );

            allTraits[i].ARMOR.img_data = substring(
                allTraits[i].ARMOR.img_data,
                22,
                bytes(allTraits[i].ARMOR.img_data).length - 1
            );

            allTraits[i].HEAD.img_data = substring(
                allTraits[i].HEAD.img_data,
                22,
                bytes(allTraits[i].HEAD.img_data).length - 1
            );

            allTraits[i].WEAPON.img_data = substring(
                allTraits[i].WEAPON.img_data,
                22,
                bytes(allTraits[i].WEAPON.img_data).length - 1
            );
        }

        return allTraits;
    }

    // use `deployer` from `ScaffoldETHDeploy`
    function run() external //ScaffoldEthDeployerRunner
    {
        Traits[] memory allTraits = getTraits2();
        Traits[] memory allTraitsTrimmed = trimAllTraitsImage(allTraits);

        // uint16[] memory backgroundRarities = new uint16[](allTraits.length);
        // FarcastleSideNFTs.Payload[] memory backgroundPayloads = new FarcastleSideNFTs.Payload[](
        //     allTraits.length
        // );

        // for (uint256 i = 0; i < allTraits.length; i++) {
        //     backgroundRarities[i] = allTraits[i].BACKGROUND.rarity;
        //     backgroundPayloads[i] = FarcastleSideNFTs.Payload(
        //         allTraits[i].BACKGROUND.name,
        //         bytes(allTraits[i].BACKGROUND.img_data)
        //     );
        // }

        // #1 [] - Layer
        // #2 [] - Value
        (
            uint16[][] memory raritiesByLayer,
            FarcastleSideNFTs.Payload[][] memory payloadsByLayer
        ) = yes1(allTraitsTrimmed);

        // for (uint256 i = 0; i < payloadsByLayer.length; i++) {
        //     for (uint256 j = 0; j < payloadsByLayer[i].length; j++) {
        //         console.log(
        //             "Layer ",
        //             i,
        //             ", Value ",
        //             payloadsByLayer[i][j].name
        //         );
        //     }
        // }
        uint256 batchAmount = 1;

        // #1 [] - Layer
        // #2 [] - Batch
        // #3 [] - Value
        uint16[][][] memory batchedRaritiesByLayer = new uint16[][][](
            payloadsByLayer.length
        );
        FarcastleSideNFTs.Payload[][][]
            memory batchedPayloadsByLayer = new FarcastleSideNFTs.Payload[][][](
                payloadsByLayer.length
            );

        for (uint256 i = 0; i < payloadsByLayer.length; i++) {
            FarcastleSideNFTs.Payload[] memory layerPayloads = payloadsByLayer[
                i
            ];
            uint16[] memory layerRarities = raritiesByLayer[i];

            uint16[][] memory batchedRaritiesForLayer = new uint16[][](
                (layerPayloads.length / batchAmount) + 1
            );
            FarcastleSideNFTs.Payload[][]
                memory batchedPayloadsForLayer = new FarcastleSideNFTs.Payload[][](
                    (layerPayloads.length / batchAmount) + 1
                );

            uint256 amountLeftToBatch = layerPayloads.length;

            uint256 batchCount = 0;
            for (uint256 j = 0; j < layerPayloads.length; j += batchAmount) {
                FarcastleSideNFTs.Payload[]
                    memory batchOfPayloads = new FarcastleSideNFTs.Payload[](
                        batchAmount
                    );
                uint16[] memory batchOfRarities = new uint16[](batchAmount);

                for (uint256 x = 0; x < batchAmount; x++) {
                    console.log(j);
                    // console.log(j + x);

                    batchOfPayloads[x] = layerPayloads[j + x];
                    batchOfRarities[x] = layerRarities[j + x];

                    amountLeftToBatch--;
                    if (amountLeftToBatch == 0) {
                        break;
                    }
                }

                batchedPayloadsForLayer[batchCount] = batchOfPayloads;
                batchedRaritiesForLayer[batchCount] = batchOfRarities;
                batchCount++;
            }

            batchedPayloadsByLayer[i] = batchedPayloadsForLayer;
            batchedRaritiesByLayer[i] = batchedRaritiesForLayer;
        }

        startBroadcast();
        FarcastleSideNFTs farcastle2 = new FarcastleSideNFTs("Test", "TEST");
        stopBroadcast();

        for (uint i = 0; i < batchedPayloadsByLayer.length; i++) {
            for (uint j = 0; j < batchedPayloadsByLayer[i].length; j++) {
                vm.startBroadcast();
                farcastle2.addTraits(
                    uint8(i),
                    batchedPayloadsByLayer[i][j],
                    batchedRaritiesByLayer[i][j]
                );

                vm.stopBroadcast();
            }
        }

        // for (uint256 j = 0; j < __backgroundPayloads.length; j++) {
        //     vm.startBroadcast();
        //     farcastle2.addTraits(
        //         0,
        //         __backgroundPayloads[j],
        //         __backgroundRarities[j]
        //     );
        //     vm.stopBroadcast();
        // }

        // FarcastleSideNFTs.Payload[][]
        //     memory __backgroundPayloads = new FarcastleSideNFTs.Payload[][](
        //         allTraits.length
        //     );
        // uint16[][] memory __backgroundRarities = new uint16[][](
        //     allTraits.length
        // );

        // for (uint256 j = 0; j < backgroundPayloads.length; j += batchAmount) {
        //     FarcastleSideNFTs.Payload[]
        //         memory _backgroundPayloads = new FarcastleSideNFTs.Payload[](
        //             batchAmount
        //         );
        //     uint16[] memory _backgroundRarities = new uint16[](batchAmount);

        //     for (uint256 i = 0; i < batchAmount; i++) {
        //         _backgroundPayloads[i] = backgroundPayloads[i];
        //         _backgroundRarities[i] = backgroundRarities[i];
        //     }

        //     __backgroundPayloads[j] = _backgroundPayloads;
        //     __backgroundRarities[j] = _backgroundRarities;
        //     // }
        // }

        // startBroadcast();
        // FarcastleSideNFTs farcastle2 = new FarcastleSideNFTs("Test", "TEST");
        // stopBroadcast();

        // for (uint256 j = 0; j < __backgroundPayloads.length; j++) {
        //     vm.startBroadcast();
        //     farcastle2.addTraits(
        //         0,
        //         __backgroundPayloads[j],
        //         __backgroundRarities[j]
        //     );
        //     vm.stopBroadcast();
        // }
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
