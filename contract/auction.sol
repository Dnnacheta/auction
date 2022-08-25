// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        highestBid = _startingBid;
    }

    // seller starts the aution and transfers nft to this contract
    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "Sorry your're not seller");

        // nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endAt = uint32(block.timestamp + 30);
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    // biider will send ethers to contract 
    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "Sorry, value is less than the highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    // bidders can withdraw bid if not the highest bidder
    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    // seller can end the aution and withdraw eth or nft if no bids
    function end() external {
        // require(msg.sender == seller, "You're not the seller");
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}


interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

