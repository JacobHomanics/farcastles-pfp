"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import type { NextPage } from "next";
import { formatEther } from "viem";
import { useBlockNumber, usePublicClient } from "wagmi";
import { AttackSlider } from "~~/components/AttackSlider";
import { useScaffoldContract, useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const [nfts, setNfts] = useState<any[]>([]);

  const { data: Farcastles } = useScaffoldContract({ contractName: "SouthNFTs" });

  const { data: totalSupply } = useScaffoldReadContract({
    contractName: "SouthNFTs",
    functionName: "totalSupply",
  });

  // const { writeContractAsync } = useScaffoldWriteContract("SouthNFTs");

  const { data: currentHealthNorth } = useScaffoldReadContract({
    contractName: "FarCASTLE",
    functionName: "s_currentHealth",
  });

  const { data: costPerAttackNorth } = useScaffoldReadContract({
    contractName: "FarCASTLEController",
    functionName: "getCostPerAttack",
  });

  const { writeContractAsync: writeNorthCastleControllerAsync } = useScaffoldWriteContract("FarCASTLEController");

  const publicClient = usePublicClient();
  useEffect(() => {
    async function fetchTokenURIs() {
      if (!publicClient?.chain.id || !Farcastles?.abi || !Farcastles?.address || !totalSupply) {
        console.log("Required data not available");
        return;
      }

      const newImgSrcs = [];
      for (let i = 1; i <= totalSupply; i++) {
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
  }, [publicClient, Farcastles, nfts, totalSupply]);

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

  const [isPopupOpen, setIsPopupOpen] = useState(false);
  const [isPopupSliderOpen, setIsPopupSliderOpen] = useState(false);
  const [selectedPopupAttack, setSelectedPopupAttack] = useState("");

  const initialValue = 3;
  const [attackPower, setAttackPower] = useState(initialValue);

  const handleSliderChange = (value: any) => {
    setAttackPower(value);
  };

  return (
    <>
      <div className="flex flex-col justify-center items-center gap-20 mt-4">
        <div className="flex flex-col items-center">
          <Image src="/castle-red.png" width={256} height={256} alt="farcastle" />
          <div className="rounded-full bg-secondary p-4">{currentHealthNorth?.toString()}</div>
          {/* <button
            className="btn btn-primary"
            onClick={async () => {
              await writeNorthCastleControllerAsync({
                functionName: "attack",
                args: [BigInt(1)],
                value: parseEther("0.1"),
                gas: BigInt(10000000),
                // gasPrice: BigInt(100000000),
              });

              setNorthHealth(northHealth - 1);

              // try {
              //   await writeContractAsync({
              //     functionName: "mint",
              //     args: [connectedAddress, BigInt(20)],
              //   });
              // } catch (error) {
              //   console.error("Error minting NFT:", error);
              // }
            }}
          >
            {"!attack north"}
          </button> */}
        </div>

        <button className="btn btn-primary btn-lg" onClick={() => setIsPopupOpen(true)}>
          Attack
        </button>
        <div className="flex flex-col items-center">
          {/* <button className="btn btn-primary" onClick={() => setSouthHealth(southHealth - 1)}>
            {"!attack south"}
          </button> */}
          <div className="rounded-full bg-secondary p-4">{currentHealthNorth?.toString()}</div>
          <Image src="/castle-red.png" width={256} height={256} alt="farcastle" />
        </div>
      </div>

      <div className="flex flex-wrap justify-center">{jsonComponents}</div>

      {isPopupOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
          <div className="bg-base-100 p-6 rounded-lg max-w-md w-full text-center shadow-lg">
            {isPopupSliderOpen ? (
              <div>
                <h2 className="text-2xl font-semibold mb-4">
                  {`What might will you strike into the ${selectedPopupAttack}?`}{" "}
                </h2>

                <div className="bg">
                  <AttackSlider min={1} max={20} step={1} initialValue={3} onValueChange={handleSliderChange}>
                    <div className="flex flex-col">
                      <div className="text-center m-0">Attack Power</div>
                      <div className="text-center m-0 text-md">
                        {"(" + formatEther(BigInt(attackPower) * (costPerAttackNorth || BigInt(0))) + ") ether"}
                      </div>

                      <div className="text-center m-0 text-xl">{attackPower}</div>
                    </div>
                  </AttackSlider>
                </div>

                <button
                  className="btn btn-primary"
                  onClick={async () => {
                    await writeNorthCastleControllerAsync({
                      functionName: "attack",
                      args: [BigInt(attackPower)],
                      value: BigInt(attackPower) * (costPerAttackNorth || BigInt(0)),
                      gas: BigInt(10000000),
                      // gasPrice: BigInt(100000000),
                    });
                  }}
                >
                  {"Attack!"}
                </button>
              </div>
            ) : (
              <div>
                <h2 className="text-2xl font-semibold mb-4">Which do you pledge allegiance to?</h2>

                <div className="flex flex-col gap-1">
                  <button
                    className="btn btn-primary"
                    onClick={async () => {
                      setIsPopupSliderOpen(true);
                      setSelectedPopupAttack("South");
                    }}
                  >
                    North
                  </button>

                  <button
                    className="btn btn-primary"
                    onClick={async () => {
                      setIsPopupSliderOpen(true);
                      setSelectedPopupAttack("North");
                    }}
                  >
                    South
                  </button>
                </div>
              </div>
            )}

            <div className="flex flex-wrap items-center justify-center mt-10">
              {isPopupSliderOpen && (
                <button
                  onClick={() => {
                    setIsPopupSliderOpen(false);
                  }}
                  className="btn btn-primary rounded-md"
                >
                  Back
                </button>
              )}

              <button
                onClick={() => {
                  setIsPopupOpen(false);
                  setIsPopupSliderOpen(false);
                }}
                className="btn rounded-md bg-red-500 hover:bg-red-600"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default Home;
