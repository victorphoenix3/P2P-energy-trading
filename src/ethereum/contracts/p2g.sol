// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract p2g{
    int currentGridPrice;
    int cPrice = currentGridPrice;
    uint currentTime = block.timestamp;
    uint peakHourStart ;
    uint peakHourEnd;
    int marketPrice;

    struct record {
        address user;
        int amt; // amt = price*energy
    }

    //record transactions between user and Grid corresponding to block number
    mapping(uint => record) p2gTransaction;
    // record of each user account 
    mapping(address => int) amtDue; 

    constructor(){
        currentGridPrice = 8;
        cPrice = currentGridPrice;
        peakHourStart = 11*1 hours; // 11 am
        peakHourEnd = 16*1 hours; // 4 pm
        marketPrice = 5;
    }

    function buyEnergy(address buyerAdd, int energyAmt) public{

        if(!buyerApproved()) return;

        if(currentTime<= peakHourEnd && currentTime>=peakHourStart){
            //price increased by 20%
            cPrice = cPrice + (20*cPrice)/100;
        }
        else{
            //price decreased by 5%
            cPrice = cPrice - (cPrice*5)/100;
        }

        amtDue[buyerAdd] += cPrice*energyAmt;

        //record transaction 
        record memory transaction;
        transaction.user = buyerAdd;
        transaction.amt = amtDue[buyerAdd];
        p2gTransaction[block.number] = transaction;

    }
    function sellEnergy(address sellerAdd, int energyAmt) public{
         
        amtDue[sellerAdd] -= marketPrice*energyAmt;
        
        record memory transaction;
        transaction.user = sellerAdd;
        transaction.amt = amtDue[sellerAdd];
        p2gTransaction[block.number] = transaction;
        //record transaction 
    }
    
    function getUserDetail(address userAdd) public view returns (int){
        return amtDue[userAdd];
    }

    function buyerApproved() public pure returns (bool){
        return true;
    }
}