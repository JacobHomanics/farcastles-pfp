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
