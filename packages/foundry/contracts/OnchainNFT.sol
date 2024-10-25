//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/Base64.sol";

contract OnchainNft {
    struct Attribute {
        string name;
        string value;
    }

    function _generateMetadata(
        string memory name,
        string memory description,
        Attribute[] memory attributes,
        string[] memory svgComponents
    ) internal pure returns (string memory metadata) {
        string memory metadataName = string(abi.encodePacked(name));
        string memory metadataDescription = string(
            abi.encodePacked(description)
        );

        metadata = string.concat(metadata, '{"name":"');
        metadata = string.concat(metadata, metadataName);
        metadata = string.concat(metadata, '", "description":"');
        metadata = string.concat(metadata, metadataDescription);
        metadata = string.concat(metadata, '"');

        string memory image = Base64.encode(bytes(_generateSvg(svgComponents)));
        metadata = string.concat(metadata, ', "image": "');
        metadata = string.concat(metadata, "data:image/svg+xml;base64,");
        metadata = string.concat(metadata, image);
        metadata = string.concat(metadata, '",');

        metadata = string.concat(metadata, _generateAttributes(attributes));

        metadata = string.concat(metadata, "}");
    }

    function _generateSvg(
        string[] memory components
    ) internal pure returns (string memory) {
        string memory svg = string(
            abi.encodePacked(
                '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
                _renderToken(components),
                "</svg>"
            )
        );

        return svg;
    }

    function _generateAttributes(
        Attribute[] memory attributes
    ) internal pure returns (string memory data) {
        for (uint256 i = 0; i < attributes.length; i++) {
            if (i == 0) {
                data = string.concat(data, '"attributes": [');
            }

            data = string.concat(data, '{"trait_type": "');
            data = string.concat(data, attributes[i].name);
            data = string.concat(data, '", "value": "');
            data = string.concat(data, attributes[i].value);

            if (i == attributes.length - 1) {
                data = string.concat(data, '"}]');
            } else {
                data = string.concat(data, '"},');
            }
        }
    }

    function _renderToken(
        string[] memory components
    ) internal pure returns (string memory fullComposition) {
        for (uint256 i = 0; i < components.length; i++) {
            fullComposition = string.concat(fullComposition, components[i]);
        }

        fullComposition = string(abi.encodePacked(fullComposition));
    }

    function renderToken(
        string[] memory components
    ) public pure returns (string memory render) {
        render = _renderToken(components);
    }

    function generateMetadata(
        string memory name,
        string memory description,
        Attribute[] memory attributes,
        string[] memory svgComponents
    ) public pure returns (string memory metadata) {
        metadata = _generateMetadata(
            name,
            description,
            attributes,
            svgComponents
        );
        metadata = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(bytes(abi.encodePacked(metadata)))
            )
        );
    }
}
