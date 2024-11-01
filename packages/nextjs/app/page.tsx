"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import type { NextPage } from "next";
import { useAccount, useBlockNumber, usePublicClient } from "wagmi";
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const [nfts, setNfts] = useState<any[]>([]);

  const { address: connectedAddress } = useAccount();

  const { data: Farcastles } = useScaffoldContract({ contractName: "Farcastles2" });

  const publicClient = usePublicClient();
  useEffect(() => {
    async function fetchTokenURIs() {
      if (!publicClient?.chain.id || !Farcastles?.abi || !Farcastles?.address) {
        console.log("Required data not available");
        return;
      }

      const newImgSrcs = [];
      for (let i = 1; i <= 400; i++) {
        try {
          const tokenURI = await publicClient.readContract({
            address: Farcastles.address,
            abi: Farcastles.abi,
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
  }, [publicClient, Farcastles, nfts]);

  console.log(nfts);
  // const { data: farcastleContract } = useScaffoldReadContract({
  //   contractName: "Farcastles",
  //   functionName: "tokenURI",
  //   args: [BigInt(1)],
  // });

  // console.log(farcastleContract?.substring(29, farcastleContract.length - 1));

  // if (farcastleContract) {
  //   const base64String = farcastleContract.substring(22, farcastleContract.length);
  //   console.log(base64String);

  //   const jsonObject = JSON.parse(base64String);
  //   console.log(jsonObject);
  //   imgSrc = jsonObject["image"];
  // }
  // if (farcastleContract) {
  //   let base64String = farcastleContract.substring(29, farcastleContract.length - 1);

  //   console.log(base64String);
  //   // Step 1: Decode the Base64 string
  //   const decodedString = Buffer.from(base64String, "base64");

  //   // Step 2: Parse the decoded string into a JSON object
  //   const jsonObject = JSON.parse(decodedString.toString());
  //   console.log(jsonObject);
  //   imgSrc = jsonObject["img_data"];
  //   // console.log(jsonObject);
  // }

  // console.log(imgSrc);

  // const imgComponents = imgSrcs.map((src, index) => (
  //   <div key={index} className="flex items-center justify-center p-4">
  //     <div className="bg-base-100 p-1">
  //       <Image src={src} width={64} height={64} alt="farcastle" />
  //     </div>
  //   </div>
  // ));

  const { data: blockNumber } = useBlockNumber();
  console.log(blockNumber);

  const jsonComponents = nfts.map((nft, index) => (
    <div key={index} className="flex items-center justify-center p-4">
      <div className="bg-base-100 p-1">
        <Image src={nft.image} width={64} height={64} alt="farcastle" />
        <div className="flex flex-col text-center">
          <p className="m-0">Name</p>
          <p className="m-0">{nft.name}</p>
        </div>

        <p className="text-center m-0 mt-4">Attributes</p>

        {nft.attributes.map((attribute: any, attributeIndex: number) => (
          <div key={"attributes" + attributeIndex} className="flex flex-col text-center">
            <p className="m-0">{attribute["trait_type"]}</p>
            <p className="m-0">{attribute["value"]}</p>
          </div>
        ))}
      </div>
    </div>
  ));

  return (
    <>
      <div className="flex flex-wrap justify-center">{jsonComponents}</div>

      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-2xl mb-2">Welcome to</span>
            <span className="block text-4xl font-bold">Scaffold-ETH 2</span>
          </h1>
          <div className="flex justify-center items-center space-x-2 flex-col sm:flex-row">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>

          <p className="text-center text-lg">
            Get started by editing{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              packages/nextjs/app/page.tsx
            </code>
          </p>
          <p className="text-center text-lg">
            Edit your smart contract{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              YourContract.sol
            </code>{" "}
            in{" "}
            <code className="italic bg-base-300 text-base font-bold max-w-full break-words break-all inline-block">
              packages/hardhat/contracts
            </code>
          </p>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="flex justify-center items-center gap-12 flex-col sm:flex-row">
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <BugAntIcon className="h-8 w-8 fill-secondary" />
              <p>
                Tinker with your smart contract using the{" "}
                <Link href="/debug" passHref className="link">
                  Debug Contracts
                </Link>{" "}
                tab.
              </p>
            </div>
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <MagnifyingGlassIcon className="h-8 w-8 fill-secondary" />
              <p>
                Explore your local transactions with the{" "}
                <Link href="/blockexplorer" passHref className="link">
                  Block Explorer
                </Link>{" "}
                tab.
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
