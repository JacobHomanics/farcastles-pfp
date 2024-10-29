// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/Farcastles2.sol";

contract Farcastles2Test is Test {
    Farcastles2 public farcastles2;

    function setUp() public {
        farcastles2 = new Farcastles2("Farcastles2", "FARC2");
    }

    function testNameAndSymbolOnDeployment() public view {
        assertEq(farcastles2.name(), "Farcastles2");
        assertEq(farcastles2.symbol(), "FARC2");
    }

    function testAddTrait() public {
        string memory name = "Test Trait";
        string
            memory imageBase64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=";

        uint16 rarity = 100;

        farcastles2.addTrait(
            Farcastles2.Payload({name: name, image: bytes(imageBase64)}),
            rarity
        );

        assertEq(farcastles2.getTrait(0).name, name);
        assertEq(farcastles2.getTrait(0).image, bytes(imageBase64));
        assertEq(farcastles2.s_traitCount(), 1);
        assertEq(farcastles2.s_traitRarities(0), rarity);

        // console.log(ImageLibrary.getTraitImage(bytes(imageBase64)));
    }

    function testGetRandomTraitIndex() public {
        string memory name = "Test Trait";
        string
            memory imageBase64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=";

        uint16 rarity = 2000;

        farcastles2.addTrait(
            Farcastles2.Payload({
                name: string.concat(name, "1"),
                image: bytes(imageBase64)
            }),
            rarity
        );

        farcastles2.addTrait(
            Farcastles2.Payload({
                name: string.concat(name, "2"),
                image: bytes(imageBase64)
            }),
            rarity
        );

        farcastles2.addTrait(
            Farcastles2.Payload({
                name: string.concat(name, "3"),
                image: bytes(imageBase64)
            }),
            rarity
        );

        farcastles2.addTrait(
            Farcastles2.Payload({
                name: string.concat(name, "4"),
                image: bytes(imageBase64)
            }),
            rarity
        );

        uint256 seed = farcastles2.getRandomSeed(16);
        uint256 rand = farcastles2.getSeedModulus(seed, 10000);

        console.log(seed);
        console.log(rand);

        uint256 traitIndex = farcastles2.getRandomTraitIndex(13);

        console.log(traitIndex);

        farcastles2.mint(0x42bcD9e66817734100b86A2bab62d9eF3B63E92A, 3);

        Farcastles2.Knight memory knight = farcastles2.getTokenTraits(3);

        console.log(knight.weapon);

        console.log(farcastles2.tokenURI(0));

        console.log(farcastles2.getTokenTraits(0).weapon);
        console.log(farcastles2.getTokenTraits(1).weapon);
        console.log(farcastles2.getTokenTraits(2).weapon);
        console.log(farcastles2.getTokenTraits(3).weapon);

        // uint256 seed = farcastles2.getRandomTraitIndex(5);
        // console.log(seed);
        // uint256 traitIndex = farcastles2.getRandomTraitIndex();

        // console.log(farcastles2.s_traitRarities(0));
        // console.log(farcastles2.s_traitRarities(1));
        // console.log(farcastles2.s_traitRarities(2));
        // console.log(farcastles2.s_traitRarities(3));
        // console.log(traitIndex);
    }

    function testGetTraitImage(uint256 traitIndex) public {}
}
