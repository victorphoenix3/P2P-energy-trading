// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./p2p.sol";
import "./p2g.sol";

contract mainContract {
 
    //contract instances to use imported contracts
    p2p P2P;
    p2g P2G;
    
    uint startTime; // auction start time

    // requester details
    struct requester {
        address requesterAdd;
        uint tag;
        int bid;
        int energyAmt;
    }
    
    //record transaction of each user (in terms of address and monetary value)
    mapping(address => int) account;
    //array of all users
    address[] users;

    constructor(address _p2p, address _p2g) {
        P2P = p2p(_p2p);
        P2G = p2g(_p2g);
        startTime = 10*1 hours; // random value
    }
     
    //requesters registration and spliting them into sellers and buyers
    function addProsumer(address requesterAdd, uint tag, int bid, int energyAmt, uint flag) public {
        account[requesterAdd] = 100; // starting every user's account with 100 value
        users.push(requesterAdd); 
        if (flag == 1) {
            P2P.addSeller(requesterAdd, tag, bid, energyAmt);
        }
        else {
            P2P.addBuyer(requesterAdd, tag, energyAmt);
        }
    }
    
    function transaction() public {
        if(block.timestamp == 900+startTime*1 seconds) { // biding time ends 

            P2P.clearMarket(); //peer to peer transaction

            address curAdd;
            int energyAmt;
            
            /* After P2P transactions, if still prosumers are remaining, then
            Transaction with Grid occur */
            if (P2P.buyLength()>0){
                for(uint i = 0; i<P2P.buyLength(); i++){
                    (curAdd, energyAmt) = P2P.getBuyer(i); //getting energy amount after P2P transaction
                    P2G.buyEnergy(curAdd,energyAmt); 
                }
            }

            if(P2P.sellLength()>0) {
                for(uint i = 0; i<P2P.sellLength(); i++) {
                    (curAdd, energyAmt) = P2P.getSeller(i);
                    P2G.sellEnergy(curAdd,energyAmt);
                }
            }
        }
    }
    // Updating account of each user after P2P and P2G transaction
    function userDetail() public{
        for(uint i = 0; i<users.length; i++){
            address add = users[i];
            account[add]-= (P2P.getUserDetail(add) + P2G.getUserDetail(add)); 
        }
    }
}