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

    // struct TraitJson {
    //     string imgData;
    //     string name;
    //     uint256 rarity;
    // }

    // struct Payload {
    //     string name;
    //     string imgData;
    // }

    // Payload[] s_payloads;

    function getTraits2() internal view returns (Traits[] memory traits) {
        string memory root = vm.projectRoot();

        string memory path = string.concat(root, "/script/1337.json");
        string memory json = vm.readFile(path);
        bytes memory data = vm.parseJson(json);

        traits = abi.decode(data, (Traits[]));
    }

    // function getTraits(
    //     uint256 index
    // ) internal view returns (Traits[] memory traits) {
    //     string memory root = vm.projectRoot();

    //     string memory path = string.concat(
    //         root,
    //         string.concat("/script/1337-split-", vm.toString(index), ".json")
    //     );
    //     string memory json = vm.readFile(path);
    //     bytes memory data = vm.parseJson(json);

    //     traits = abi.decode(data, (Traits[]));
    // }

    // function addTrait(
    //     Farcastles farcastle,
    //     uint8 layer,
    //     string memory name,
    //     string memory imgData,
    //     uint16 rarity
    // ) internal {
    //     Farcastles.Payload memory newPayload = Farcastles.Payload(
    //         name,
    //         // bytes(imgData)
    //         bytes(substring(imgData, 22, bytes(imgData).length - 1))
    //     );

    //     // console.log(substring(imgData, 22, bytes(imgData).length - 1));

    //     farcastle.addTrait(layer, newPayload, rarity);
    // }

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

        uint256 batchAmount = 2;

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
        // ScaffoldERC721A.ScaffoldERC721AParameters
        //     memory params = ScaffoldERC721A.ScaffoldERC721AParameters(
        //         msg.sender,
        //         "Pizza People",
        //         "PP",
        //         "ipfs://bafybeigwxkkv7fl6aedo726uzovnoxphwweclvnpgb55hhtwnyulnewnv4/",
        //         0,
        //         0,
        //         0,
        //         1000,
        //         1000,
        //         msg.sender,
        //         new address[](0)
        //     );

        // Farcastles farcastle = new Farcastles(params);

        // Traits[] memory allTraits = getTraits2();

        // uint16[] memory backgroundRarities = new uint16[](allTraits.length);
        // SouthNFTs.Payload[] memory backgroundPayloads = new SouthNFTs.Payload[](
        //     allTraits.length
        // );

        // for (uint256 i = 0; i < allTraits.length; i++) {
        //     backgroundRarities[i] = allTraits[i].BACKGROUND.rarity;
        //     backgroundPayloads[i] = SouthNFTs.Payload(
        //         allTraits[i].BACKGROUND.name,
        //         bytes(allTraits[i].BACKGROUND.img_data)
        //     );
        // }

        // uint256 batchAmount = 5;

        SouthNFTs farcastle2 = new SouthNFTs("Test", "TEST");
        stopBroadcast();

        for (uint256 j = 0; j < __backgroundPayloads.length; j++) {
            vm.startBroadcast();

            farcastle2.addTraits(
                0,
                __backgroundPayloads[j],
                __backgroundRarities[j]
            );
            vm.stopBroadcast();
        }

        // for (uint256 j = 0; j < backgroundPayloads.length; j += batchAmount) {
        //     SouthNFTs.Payload[]
        //         memory _backgroundPayloads = new SouthNFTs.Payload[](
        //             batchAmount
        //         );
        //     uint16[] memory _backgroundRarities = new uint16[](batchAmount);

        //     for (uint256 i = 0; i < batchAmount; i++) {
        //         _backgroundPayloads[i] = backgroundPayloads[j + i];
        //         _backgroundRarities[i] = backgroundRarities[j + i];
        //     }

        //     farcastle2.addTraits(0, _backgroundPayloads, _backgroundRarities);
        // }

        // for (uint256 i = 0; i < allTraits.length; i++) {

        //     uint256 batchAmount = 30;
        //     for (uint256 j = 0; j < batchAmount; j++) {
        //     }
        // }

        console.log(allTraits[0].BACKGROUND.name);
        // Traits[][] memory allTraits = new Traits[][](3);
        // for (uint256 i = 1; i <= 2; i++) {
        //     Traits[] memory traits = getTraits(i);
        //     allTraits[i] = traits;
        // }

        // uint256 x = 0;
        // for (uint256 i = 0; i < allTraits.length; i++) {
        //     for (uint8 j = 0; j < allTraits[i].length; j++) {
        //         // console.log(allTraits[i][j].BACKGROUND.name);
        //         // console.log(allTraits[i][j].ARMOR.name);
        //         // console.log(allTraits[i][j].HEAD.name);
        //         // console.log(allTraits[i][j].WEAPON.name);

        //         console.log(x);
        //         x++;
        //         console.log(allTraits[i][j].BACKGROUND.name);

        //         farcastle2.addTraits(
        //             SouthNFTs.MultiPayload({
        //                 layers: [uint8(0)],
        //                 name: [allTraits[i][j].BACKGROUND.name],
        //                 imgData: [allTraits[i][j].BACKGROUND.img_data],
        //                 rarity: [allTraits[i][j].BACKGROUND.rarity]
        //         }));

        //         farcastle2.addTrait(
        //             0,
        //             SouthNFTs.Payload({
        //                 name: allTraits[i][j].BACKGROUND.name,
        //                 image: bytes(
        //                     substring(
        //                         allTraits[i][j].BACKGROUND.img_data,
        //                         22,
        //                         bytes(allTraits[i][j].BACKGROUND.img_data)
        //                             .length - 1
        //                     )
        //                 )
        //             }),
        //             allTraits[i][j].BACKGROUND.rarity
        //         );

        //         farcastle2.addTrait(
        //             1,
        //             SouthNFTs.Payload({
        //                 name: allTraits[i][j].ARMOR.name,
        //                 image: bytes(
        //                     substring(
        //                         allTraits[i][j].ARMOR.img_data,
        //                         22,
        //                         bytes(allTraits[i][j].ARMOR.img_data).length - 1
        //                     )
        //                 )
        //             }),
        //             allTraits[i][j].ARMOR.rarity
        //         );

        //         farcastle2.addTrait(
        //             2,
        //             SouthNFTs.Payload({
        //                 name: allTraits[i][j].HEAD.name,
        //                 image: bytes(
        //                     substring(
        //                         allTraits[i][j].HEAD.img_data,
        //                         22,
        //                         bytes(allTraits[i][j].HEAD.img_data).length - 1
        //                     )
        //                 )
        //             }),
        //             allTraits[i][j].HEAD.rarity
        //         );

        //         farcastle2.addTrait(
        //             3,
        //             SouthNFTs.Payload({
        //                 name: allTraits[i][j].WEAPON.name,
        //                 image: bytes(
        //                     substring(
        //                         allTraits[i][j].WEAPON.img_data,
        //                         22,
        //                         bytes(allTraits[i][j].WEAPON.img_data).length -
        //                             1
        //                     )
        //                 )
        //             }),
        //             allTraits[i][j].WEAPON.rarity
        //         );

        //         // addTrait(
        //         //     farcastle,
        //         //     0,
        //         //     allTraits[i][j].BACKGROUND.name,
        //         //     allTraits[i][j].BACKGROUND.img_data,
        //         //     allTraits[i][j].BACKGROUND.rarity
        //         // );

        //         // addTrait(
        //         //     farcastle,
        //         //     1,
        //         //     allTraits[i][j].ARMOR.name,
        //         //     allTraits[i][j].ARMOR.img_data,
        //         //     allTraits[i][j].ARMOR.rarity
        //         // );

        //         // addTrait(
        //         //     farcastle,
        //         //     2,
        //         //     allTraits[i][j].HEAD.name,
        //         //     allTraits[i][j].HEAD.img_data,
        //         //     allTraits[i][j].HEAD.rarity
        //         // );

        //         // addTrait(
        //         //     farcastle,
        //         //     3,
        //         //     allTraits[i][j].WEAPON.name,
        //         //     allTraits[i][j].WEAPON.img_data,
        //         //     allTraits[i][j].WEAPON.rarity
        //         // );
        //     }
        // }

        // new FarCASTLE(55, 0.1 ether, address(farcastle2));
        // farcastle2.mint(0x42bcD9e66817734100b86A2bab62d9eF3B63E92A, 20);
    }

    // function prepLayer(
    //     Traits[] memory traits,
    //     string memory layerName
    // )
    //     internal
    //     pure
    //     returns (
    //         Farcastles.Payload[] memory payloads,
    //         uint256[] memory rarities
    //     )
    // {
    //     string[] memory names = new string[](traits.length);
    //     bytes[] memory imgDatas = new bytes[](traits.length);
    //     rarities = new uint256[](traits.length);

    //     for (uint256 i = 0; i < traits.length; i++) {
    //         if ()
    //         s_payloads.push(Payload(traits[i].name, traits[i].imgData));
    //     }

    //     for (uint256 i = 0; i < traits.length; i++) {
    //         names[i] = traits[i].name;
    //         imgDatas[i] = bytes(traits[i].imgData);
    //         rarities[i] = traits[i].rarity;
    //     }

    //     payloads = new Farcastles.Payload[](traits.length);
    //     for (uint256 i = 0; i < traits.length; i++) {
    //         payloads[i] = Farcastles.Payload(names[i], imgDatas[i]);
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
