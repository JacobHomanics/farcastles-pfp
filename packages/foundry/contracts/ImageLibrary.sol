//SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../lib/ERC721A/contracts/ERC721A.sol";
import "../lib/solady/src/utils/Base64.sol";

library ImageLibrary {
    function getTraitImage(
        bytes memory image
    ) external pure returns (string memory) {
        return
            Base64.encode(
                abi.encodePacked(
                    '<svg width="100%" height="100%" viewBox="0 0 20000 20000" xmlns="http://www.w3.org/2000/svg">',
                    "<style>svg{background-color:transparent;background-image:",
                    getTraitImageData(image),
                    ";background-repeat:no-repeat;background-size:contain;background-position:center;image-rendering:-webkit-optimize-contrast;-ms-interpolation-mode:nearest-neighbor;image-rendering:-moz-crisp-edges;image-rendering:pixelated;}</style></svg>"
                )
            );
    }

    function getTraitImageData(
        bytes memory image
    ) public pure returns (string memory) {
        return
            string(abi.encodePacked("url(data:image/png;base64,", image, ")"));
    }
}
