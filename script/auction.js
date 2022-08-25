// import { ethers } from "hardhat";
require('dotenv').config();
const ethers = require('ethers');

const GOERLI_API_KEY = process.env.GOERLI_API_KEY;
const provider = new ethers.providers.AlchemyProvider('goerli', GOERLI_API_KEY);

const privateKey = process.env.PRIVATE_KEY
const signer = new ethers.Wallet(privateKey, provider);

const contract = require("../artifacts/contracts/auction.sol/Auction.json");

const abi = contract.abi
const contractAddress = '0x1fd5fB0BB7504A0b28ffB3cE97B9851B0329A942'
const auction = new ethers.Contract(contractAddress, abi, signer);
// console.log(JSON.stringify(contract.abi));

const nftAddr = '0x21fE7704f9Bb608d1b8673c3Fe78CFFC1B1C804a';
const nftId = 0;
const startingBid = 1000;

// const proof = tree.getProof(buf2hex(keccak256(addresses[14])));
// const leaf = tree.getProof(buf2hex(keccak256(addresses[14]))).map(x => buf2hex(x.data));


const start = async () => {
    let Txn = await start()
    await Txn.wait()
    console.log(`Auction started ⏩ https://goerli.etherscan.io/tx/${Txn.hash}`) 
}

start()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});