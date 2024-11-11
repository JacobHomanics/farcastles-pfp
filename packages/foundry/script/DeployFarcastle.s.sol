//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/Farcastles.sol";
import "../contracts/FarcastleSideNFTs.sol";
import "./DeployHelpers.s.sol";
import "../contracts/FarCASTLE.sol";
import "../contracts/FarCASTLEController.sol";

import "../contracts/SouthNFTs.sol";
import "../contracts/SouthCastle.sol";
import "../contracts/SouthCastleController.sol";

import "../contracts/NorthNFTs.sol";
import "../contracts/NorthCastle.sol";
import "../contracts/NorthCastleController.sol";

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

    function getTraits2() internal view returns (Traits[] memory) {
        string memory root = vm.projectRoot();

        string memory path = string.concat(root, "/script/1337.json");
        string memory json = vm.readFile(path);
        bytes memory data = vm.parseJson(json);

        Traits[] memory traits = abi.decode(data, (Traits[]));

        Traits[] memory allTraitsTrimmed = trimAllTraitsImage(traits);

        return allTraitsTrimmed;
    }

    struct CompleteTraits {
        uint16[][] rarities;
        FarcastleSideNFTs.Payload[][] payloads;
    }

    function yes1(
        Traits[] memory allTraits
    ) public pure returns (CompleteTraits memory) {
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

        return CompleteTraits(rarities, payloads);
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

    uint256 batchAmount = 10;

    struct CompleteTraits2 {
        uint16[][][] rarities;
        FarcastleSideNFTs.Payload[][][] payloads;
    }

    function yes1234(
        CompleteTraits memory completeTraits
    ) public view returns (CompleteTraits2 memory) {
        uint16[][][] memory batchedRaritiesByLayer = new uint16[][][](
            completeTraits.payloads.length
        );
        FarcastleSideNFTs.Payload[][][]
            memory batchedPayloadsByLayer = new FarcastleSideNFTs.Payload[][][](
                completeTraits.payloads.length
            );

        for (uint256 i = 0; i < completeTraits.payloads.length; i++) {
            FarcastleSideNFTs.Payload[] memory layerPayloads = completeTraits
                .payloads[i];
            uint16[] memory layerRarities = completeTraits.rarities[i];

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

        return CompleteTraits2(batchedRaritiesByLayer, batchedPayloadsByLayer);
    }

    // use `deployer` from `ScaffoldETHDeploy`
    function run() external //ScaffoldEthDeployerRunner
    {
        Traits[] memory allTraits = getTraits2();

        // #1 [] - Layer
        // #2 [] - Value
        // (
        //     uint16[][] memory raritiesByLayer,
        //     FarcastleSideNFTs.Payload[][] memory payloadsByLayer
        // )
        CompleteTraits memory completeTraits = yes1(allTraits);

        // (
        //     uint16[][][] memory batchedRaritiesByLayer,
        //     FarcastleSideNFTs.Payload[][][] memory batchedPayloadsByLayer
        // )
        CompleteTraits2 memory completeTraits2 = yes1234(completeTraits);
        // #1 [] - Layer
        // #2 [] - Batch
        // #3 [] - Value

        startBroadcast();

        (, address _deployer, ) = vm.readCallers();

        NorthCastleController northCastleController = new NorthCastleController(
            .1 ether,
            _deployer
        );

        NorthCastle northCastle = new NorthCastle(
            150,
            address(northCastleController)
        );

        address[] memory minters = new address[](1);
        minters[0] = address(northCastleController);
        SouthNFTs southNFTs = new SouthNFTs(minters);
        northCastleController.setCastle(address(northCastle));
        northCastleController.setTroops(address(southNFTs));

        for (uint i = 0; i < completeTraits2.payloads.length; i++) {
            for (uint j = 0; j < completeTraits2.payloads[i].length; j++) {
                southNFTs.addTraits(
                    uint8(i),
                    completeTraits2.payloads[i][j],
                    completeTraits2.rarities[i][j]
                );
            }
        }

        SouthCastleController southCastleController = new SouthCastleController(
            .1 ether,
            _deployer
        );

        SouthCastle southCastle = new SouthCastle(
            150,
            address(southCastleController)
        );

        address[] memory northMinters = new address[](1);
        northMinters[0] = address(southCastleController);
        NorthNFTs northNFTs = new NorthNFTs(northMinters);
        southCastleController.setCastle(address(southCastle));
        southCastleController.setTroops(address(northNFTs));

        for (uint i = 0; i < completeTraits2.payloads.length; i++) {
            for (uint j = 0; j < completeTraits2.payloads[i].length; j++) {
                southNFTs.addTraits(
                    uint8(i),
                    completeTraits2.payloads[i][j],
                    completeTraits2.rarities[i][j]
                );
            }
        }
        // deployNorth(batchedPayloadsByLayer, batchedRaritiesByLayer);
        // deploySouth(batchedPayloadsByLayer, batchedRaritiesByLayer);

        vm.stopBroadcast();
    }

    // function deployNorth(
    //     FarcastleSideNFTs.Payload[][][] memory batchedPayloadsByLayer,
    //     uint16[][][] memory batchedRaritiesByLayer
    // ) public {
    //     (, address _deployer, ) = vm.readCallers();

    //     NorthCastleController northCastleController = new NorthCastleController(
    //         .1 ether,
    //         _deployer
    //     );

    //     NorthCastle northCastle = new NorthCastle(
    //         150,
    //         address(northCastleController)
    //     );

    //     address[] memory minters = new address[](1);
    //     minters[0] = address(northCastleController);
    //     SouthNFTs southNFTs = new SouthNFTs(minters);
    //     northCastleController.setCastle(address(northCastle));
    //     northCastleController.setTroops(address(southNFTs));

    //     for (uint i = 0; i < batchedPayloadsByLayer.length; i++) {
    //         for (uint j = 0; j < batchedPayloadsByLayer[i].length; j++) {
    //             southNFTs.addTraits(
    //                 uint8(i),
    //                 batchedPayloadsByLayer[i][j],
    //                 batchedRaritiesByLayer[i][j]
    //             );
    //         }
    //     }
    // }

    // function deploySouth(
    //     FarcastleSideNFTs.Payload[][][] memory batchedPayloadsByLayer,
    //     uint16[][][] memory batchedRaritiesByLayer
    // ) public {
    //     (, address _deployer, ) = vm.readCallers();

    //     SouthCastleController southCastleController = new SouthCastleController(
    //         .1 ether,
    //         _deployer
    //     );

    //     SouthCastle southCastle = new SouthCastle(
    //         150,
    //         address(southCastleController)
    //     );

    //     address[] memory northMinters = new address[](1);
    //     northMinters[0] = address(southCastleController);
    //     NorthNFTs northNFTs = new NorthNFTs(northMinters);
    //     southCastleController.setCastle(address(southCastle));
    //     southCastleController.setTroops(address(northNFTs));

    //     for (uint i = 0; i < batchedPayloadsByLayer.length; i++) {
    //         for (uint j = 0; j < batchedPayloadsByLayer[i].length; j++) {
    //             northNFTs.addTraits(
    //                 uint8(i),
    //                 batchedPayloadsByLayer[i][j],
    //                 batchedRaritiesByLayer[i][j]
    //             );
    //         }
    //     }
    // }

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
