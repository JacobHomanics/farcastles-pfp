"use client";

import { useState } from "react";
import Image from "next/image";
import type { NextPage } from "next";
import { Abi, formatEther, parseEventLogs } from "viem";
import { useBlockNumber } from "wagmi";
import { AttackSlider } from "~~/components/AttackSlider";
import { NFTViewer } from "~~/components/NFTViewer";
import { useDeployedContractInfo, useScaffoldReadContract, useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { data: currentHealthNorth } = useScaffoldReadContract({
    contractName: "NorthCastle",
    functionName: "s_currentHealth",
  });

  const { data: costPerAttackNorth } = useScaffoldReadContract({
    contractName: "NorthCastleController",
    functionName: "getCostPerAttack",
  });

  const { data: currentHealthSouth } = useScaffoldReadContract({
    contractName: "SouthCastle",
    functionName: "s_currentHealth",
  });

  const { data: costPerAttackSouth } = useScaffoldReadContract({
    contractName: "SouthCastleController",
    functionName: "getCostPerAttack",
  });

  console.log(costPerAttackNorth);

  const { data: deployedContractDataNorth } = useDeployedContractInfo("NorthNFTs");
  const { data: deployedContractDataSouth } = useDeployedContractInfo("SouthNFTs");

  const { writeContractAsync: writeNorthCastleControllerAsync } = useScaffoldWriteContract("NorthCastleController");

  const { writeContractAsync: writeSouthCastleControllerAsync } = useScaffoldWriteContract("SouthCastleController");

  const { data: blockNumber } = useBlockNumber();
  console.log(blockNumber);

  const [isPopupOpen2, setIsPopupOpen2] = useState(false);

  const [isPopupOpen, setIsPopupOpen] = useState(false);
  const [isPopupSliderOpen, setIsPopupSliderOpen] = useState(false);
  const [selectedPopupAttack, setSelectedPopupAttack] = useState("");

  const initialValue = 3;
  const [attackPower, setAttackPower] = useState(initialValue);

  const handleSliderChange = (value: any) => {
    setAttackPower(value);
  };

  const [startIndex, setStartIndex] = useState<number | undefined>(undefined);
  const [endIndex, setEndIndex] = useState<number | undefined>(undefined);
  const [selectedPopupAttack2, setSelectedPopupAttack2] = useState("");

  return (
    <>
      <div className="flex flex-col justify-center items-center gap-10 mt-4">
        <div className="flex flex-col items-center">
          <Image src="/castle-red.png" width={256} height={256} alt="farcastle" />
          <div className="rounded-full bg-secondary p-1 w-full text-center text-4xl">
            {currentHealthNorth?.toString()}
          </div>
        </div>

        <div className="flex flex-col items-center justify-center">
          <div className="text-center m-0">Attack Power</div>
          <div className="text-center m-0 text-3xl">{attackPower}</div>
          <AttackSlider min={1} max={20} step={1} initialValue={3} onValueChange={handleSliderChange}>
            <div className="flex flex-col">
              <div className="text-center m-0 text-md">
                {"(" + formatEther(BigInt(attackPower) * (costPerAttackNorth || BigInt(0))) + ") ether"}
              </div>
            </div>
          </AttackSlider>
          <p className="text-3xl">Attack</p>
          <div className="flex flex-wrap">
            <button
              className="btn btn-primary m-0"
              onClick={async () => {
                await writeNorthCastleControllerAsync(
                  {
                    functionName: "attack",
                    args: [BigInt(attackPower)],
                    value: BigInt(attackPower) * (costPerAttackNorth || BigInt(0)),
                    // gasPrice: BigInt(100000000),
                  },
                  {
                    onBlockConfirmation: receipt => {
                      const [myEvent] = parseEventLogs({
                        abi: deployedContractDataNorth?.abi as Abi,
                        eventName: "Mint",
                        logs: receipt.logs,
                      });

                      console.log(myEvent);

                      if (myEvent && "startIndex" in myEvent.args) {
                        setStartIndex(Number(myEvent.args.startIndex));
                      }

                      if (myEvent && "amount" in myEvent.args) {
                        setEndIndex(Number(myEvent.args.amount));
                      }

                      setSelectedPopupAttack2("SouthNFTs");
                    },
                  },
                );

                setIsPopupOpen2(true);
              }}
            >
              North
            </button>
            <button
              className="btn btn-primary m-0"
              onClick={async () => {
                await writeSouthCastleControllerAsync(
                  {
                    functionName: "attack",
                    args: [BigInt(attackPower)],
                    value: BigInt(attackPower) * (costPerAttackSouth || BigInt(0)),
                    // gasPrice: BigInt(100000000),
                  },
                  {
                    onBlockConfirmation: receipt => {
                      const [myEvent] = parseEventLogs({
                        abi: deployedContractDataSouth?.abi as Abi,
                        eventName: "Mint",
                        logs: receipt.logs,
                      });

                      console.log(myEvent);

                      if (myEvent && "startIndex" in myEvent.args) {
                        setStartIndex(Number(myEvent.args.startIndex));
                      }

                      if (myEvent && "amount" in myEvent.args) {
                        setEndIndex(Number(myEvent.args.amount));
                      }

                      setSelectedPopupAttack2("NorthNFTs");
                    },
                  },
                );

                setIsPopupOpen2(true);
              }}
            >
              South
            </button>
          </div>
        </div>

        <div className="flex flex-col items-center">
          <div className="rounded-full bg-secondary p-1 w-full text-center text-4xl">
            {currentHealthSouth?.toString()}
          </div>
          <Image src="/castle-red.png" width={256} height={256} alt="farcastle" />
        </div>
      </div>

      {/* <NFTViewer contractName="NorthNFTs" /> */}

      {isPopupOpen2 && (
        <div className="fixed top-0 left-0 right-0 bottom-0 bg-black bg-opacity-50 flex items-start justify-center overflow-y-auto">
          <div className="bg-base-100 p-6 rounded-lg w-full text-center shadow-lg w-[800px] mt-10 mb-10">
            <p className="text-3xl">Your new figurines!</p>
            <NFTViewer contractName={selectedPopupAttack2} startIndex={startIndex} endIndex={endIndex} />
            <button
              onClick={() => {
                setIsPopupOpen2(false);
              }}
              className="btn rounded-md bg-red-500 hover:bg-red-600 mt-4"
            >
              Close
            </button>
          </div>
        </div>
      )}
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

                      <div className="text-center m-0 text-3xl">{attackPower}</div>
                    </div>
                  </AttackSlider>
                </div>

                <button
                  className="btn btn-primary"
                  onClick={async () => {
                    if (selectedPopupAttack === "North") {
                      await writeNorthCastleControllerAsync({
                        functionName: "attack",
                        args: [BigInt(attackPower)],
                        value: BigInt(attackPower) * (costPerAttackNorth || BigInt(0)),
                        gas: BigInt(10000000),
                        // gasPrice: BigInt(100000000),
                      });
                    } else if (selectedPopupAttack === "South") {
                      await writeSouthCastleControllerAsync({
                        functionName: "attack",
                        args: [BigInt(attackPower)],
                        value: BigInt(attackPower) * (costPerAttackSouth || BigInt(0)),
                        gas: BigInt(10000000),
                        // gasPrice: BigInt(100000000),
                      });
                    }
                  }}
                >
                  {"Attack!"}
                </button>
              </div>
            ) : (
              <div>
                <h2 className="text-2xl font-semibold mb-4">Who will you attack?</h2>

                <div className="flex flex-col gap-1">
                  <button
                    className="btn btn-primary"
                    onClick={async () => {
                      setIsPopupSliderOpen(true);
                      setSelectedPopupAttack("North");
                    }}
                  >
                    North
                  </button>

                  <button
                    className="btn btn-primary"
                    onClick={async () => {
                      setIsPopupSliderOpen(true);
                      setSelectedPopupAttack("South");
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
