import React, { useEffect, useState } from "react";
import Image from "next/image";
import { usePublicClient } from "wagmi";
import { useScaffoldContract, useScaffoldReadContract } from "~~/hooks/scaffold-eth";

export const NFTViewer = ({ contractName }: any) => {
  const [nfts, setNfts] = useState<any[]>([]);

  const { data: SouthNFTS } = useScaffoldContract({ contractName: contractName as "SouthNFTs" | "NorthNFTs" });

  const { data: totalSupply } = useScaffoldReadContract({
    contractName: contractName as "SouthNFTs" | "NorthNFTs",
    functionName: "totalSupply",
  });

  const publicClient = usePublicClient();
  useEffect(() => {
    async function fetchTokenURIs() {
      if (!publicClient?.chain.id || !SouthNFTS?.abi || !SouthNFTS?.address || !totalSupply) {
        console.log("Required data not available");
        return;
      }

      const newImgSrcs = [];
      for (let i = 1; i <= totalSupply; i++) {
        try {
          const tokenURI = await publicClient.readContract({
            address: SouthNFTS.address,
            abi: SouthNFTS.abi,
            functionName: "tokenURI",
            args: [BigInt(i)],
          });

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
  }, [publicClient, SouthNFTS, nfts, totalSupply]);

  const jsonComponents = nfts.map((nft, index) => {
    console.log(nft.image);

    return (
      <div key={index} className="flex items-center justify-center p-4 w-[400px]">
        <div className="bg-base-100 p-1 flex flex-col items-center justify-center w-full">
          <Image src={nft.image} width={128} height={128} alt="farcastle" className="rounded-full" />
          <div className="flex flex-col text-center">
            <p className="m-0">Name</p>
            <p className="m-0">{nft.name}</p>
          </div>

          <p className="text-center m-0 mt-4">Attributes</p>

          {nft.attributes.map((attribute: any, attributeIndex: number) => (
            <div key={"attributes" + attributeIndex} className="flex flex-wrap gap-5 text-center">
              <p className="m-0">{attribute["trait_type"]}</p>
              <p className="m-0">{attribute["value"]}</p>
            </div>
          ))}
        </div>
      </div>
    );
  });

  return <div className="flex flex-wrap justify-center">{jsonComponents}</div>;
};
