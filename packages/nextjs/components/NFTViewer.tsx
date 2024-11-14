import React, { useEffect, useState } from "react";
import Image from "next/image";
import { usePublicClient } from "wagmi";
import { useScaffoldContract } from "~~/hooks/scaffold-eth";

export const NFTViewer = ({ contractName, startIndex, endIndex }: any) => {
  const [nfts, setNfts] = useState<any[]>([]);

  const { data: SouthNFTS } = useScaffoldContract({ contractName: contractName as "SouthNFTs" | "NorthNFTs" });

  //   const { data: totalSupply } = useScaffoldReadContract({
  //     contractName: contractName as "SouthNFTs" | "NorthNFTs",
  //     functionName: "totalSupply",
  //   });

  const publicClient = usePublicClient();
  useEffect(() => {
    async function fetchTokenURIs() {
      console.log(publicClient?.chain.id);
      console.log(SouthNFTS?.abi);
      console.log(SouthNFTS?.address);
      console.log(startIndex);
      console.log(endIndex);

      if (
        !publicClient?.chain.id ||
        !SouthNFTS?.abi ||
        !SouthNFTS?.address ||
        startIndex == undefined ||
        endIndex === undefined
      ) {
        console.log("Required data not available");
        return;
      }

      const newImgSrcs = [];
      for (let i = startIndex + 1; i <= startIndex + endIndex; i++) {
        try {
          const tokenURI = (await publicClient.readContract({
            address: SouthNFTS.address,
            abi: SouthNFTS.abi,
            functionName: "tokenURI",
            args: [BigInt(i)],
          })) as string;

          const base64String = tokenURI.substring(22);
          const jsonObject = JSON.parse(base64String);
          newImgSrcs.push(jsonObject);
        } catch (error) {
          console.error(`Error fetching token URI for token ${i}:`, error);
        }
      }

      if (JSON.stringify(newImgSrcs) !== JSON.stringify(nfts)) {
        setNfts(newImgSrcs);
      }
    }

    fetchTokenURIs();
  }, [publicClient, SouthNFTS, nfts, startIndex, endIndex]);

  const jsonComponents = nfts.map((nft, index) => {
    console.log(nft.image);

    return (
      <div key={index} className="flex items-center justify-center p-4">
        <div className="bg-base-100 p-1 flex flex-col items-center justify-center w-full bg-primary rounded-lg">
          <Image src={nft.image} width={128} height={128} alt="farcastle" className="rounded-full" />
          <div className="flex flex-col text-center">
            {/* <p className="m-0">Name</p> */}
            <p className="m-0 text-xl">{nft.name}</p>
          </div>

          <div className="flex flex-col text-center">
            {/* <p className="m-0 text-sm">Description</p> */}
            <p className="m-0 text-xs">{nft.description}</p>
          </div>

          <p className="text-center m-0 mt-4">Attributes</p>

          {nft.attributes.map((attribute: any, attributeIndex: number) => (
            <div key={"attributes" + attributeIndex} className="flex flex-wrap gap-5 text-center">
              <div className="flex flex-col">
                <div className="bg-secondary m-1 rounded-lg p-1">
                  <p className="m-0 text-sm">{attribute["trait_type"]}</p>
                  <p className="m-0 text-lg">{attribute["value"]}</p>{" "}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  });

  return <div className="flex flex-wrap justify-center">{jsonComponents}</div>;
};
