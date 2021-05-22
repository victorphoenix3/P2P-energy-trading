// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract p2p {
    int requiredEnergy = 0; //total energy requirement of all buyers
    int CPrice = 0; //final selling price after auction
    struct buyerData {
        uint tag;
        int energyAmt;
    }

    struct sellerData {
        uint tag;
        int bid;
        int energyAmt;        
    }

    // record of energy transfer
    struct record {
        address seller;
        address buyer;
        int energy;
    }
    //record transaction of each user (in terms of address and monetary value)
    //amount to be paid --> +ve 
    //amount to be received --> -ve
    mapping(address => int) amtDue; 
    
    //recording energy transfer between seller and buyer corresponding to transaction block number
    mapping(uint => record) p2pTransaction;

    mapping(address => sellerData) sellers;
    mapping(address => buyerData) buyers;

    address[] public sortedSellers;
    address[] public totSellers;
    address[] public totBuyers;

    function addSeller(address sellerAdd, uint sellerTag, int sellerBid, int sellerEnergyAmt) public {
        sellerData memory seller;
        seller.tag = sellerTag;
        seller.bid = sellerBid;
        seller.energyAmt = sellerEnergyAmt;

        sellers[sellerAdd] = seller;
        totSellers.push(sellerAdd);
    }

    function addBuyer(address buyerAdd, uint buyerTag, int buyerEnergyAmt) public {
        buyerData memory buyer;
        buyer.tag = buyerTag;
        buyer.energyAmt = buyerEnergyAmt;
        requiredEnergy += buyerEnergyAmt;
        buyers[buyerAdd] = buyer;
        totBuyers.push(buyerAdd);
    }

    function calcPrice() public returns (int) {
        uint n = totSellers.length;
        if (n==0) return 0;
        sort(); //sorting seller array in ascending order of their bid value
        uint i = 0;
        int totalEnergy = 0;
        /*intersection between cumulative energy amount sold by sellers arranged in increasing order of their bids 
        and total energy required by all buyers gives the selling price */
        while (i<n && totalEnergy<requiredEnergy) {
            totalEnergy += sellers[totSellers[i]].energyAmt;
            i++;
        }
        return sellers[totSellers[i-1]].bid;
    }

    function sort() public { //bubble sort
        for (uint i = 0; i < totSellers.length-1; i++) {
            for (uint j = 0; j < totSellers.length-i-1; j++) {    
                if (sellers[totSellers[j]].bid > sellers[totSellers[j+1]].bid) {
                    address temp = totSellers[j];
                    totSellers[j] = totSellers[j+1];
                    totSellers[j+1] = temp;
                }        
            }
        }
    }

    function clearMarket() public {
        uint i=0;
        uint j=0;

        CPrice = calcPrice(); //selling price calculation

        // matching sellers and buyers based on distance (using tags)
        for(i=0;i<totBuyers.length;i++)
        {
           for(j=0;j<totSellers.length;j++) 
           {
               if(buyers[totBuyers[i]].tag == sellers[totSellers[j]].tag)
               matchBid(j,i);
           }
        }
        
        if (totSellers.length>0 && totBuyers.length>0){
             for (i=0;i<totBuyers.length;i++){
                for (j=0;j<totSellers.length;j++){
                    if (buyers[totBuyers[i]].tag == sellers[totSellers[j]].tag+1 || buyers[totBuyers[i]].tag+1 == sellers[totSellers[j]].tag)
                        matchBid(j,i);
                }
             }
        }
        if (totSellers.length>0 && totBuyers.length>0){
             for (i=0;i<totBuyers.length;i++){
                for (j=0;j<totSellers.length;j++){
                    if (buyers[totBuyers[i]].tag == sellers[totSellers[j]].tag+2 || buyers[totBuyers[i]].tag+2 == sellers[totSellers[j]].tag)
                        matchBid(j,i);
                }
             }
        }
    }

    function matchBid(uint sellerIndex, uint buyerIndex) public {
        if(totSellers.length==0 || totBuyers.length==0){
            return;
        }
        uint i = buyerIndex; 
        uint j = sellerIndex;
        int remainder =0; int calcAmount = 0;
        // checking energy sold by seller and buyer and deciding final energy after transaction
        // removing seller or buyer after their energy demands are met
        if((sellers[totSellers[j]].energyAmt - buyers[totBuyers[i]].energyAmt)>=0){
            remainder = sellers[totSellers[j]].energyAmt - buyers[totBuyers[i]].energyAmt ;
            calcAmount = sellers[totSellers[j]].energyAmt - remainder ;
            buyEnergy(calcAmount, totBuyers[j],totSellers[i]); // recording energy transfer
            sellers[totSellers[j]].energyAmt = remainder;
            if(remainder==0){
                removeSeller(j);
            }
            removeBuyer(i);
        }
        else {
            remainder = buyers[totBuyers[i]].energyAmt - sellers[totSellers[j]].energyAmt;
            calcAmount = buyers[totBuyers[i]].energyAmt - remainder;
            buyEnergy(calcAmount, totBuyers[j], totSellers[i]);
            buyers[totBuyers[j]].energyAmt = remainder;
            if(remainder==0){
                removeBuyer(i);
            }
            removeSeller(j);
        }
    }

    function removeSeller(uint index) public {
        require(index < totSellers.length, "inappropriate call");
        delete sellers[totSellers[index]];
        totSellers[index] = totSellers[totSellers.length-1]; 
        totSellers.pop();
    }

    function removeBuyer(uint index) public {
        require(index < totBuyers.length, "inappropriate call");
        delete buyers[totBuyers[index]];
        totBuyers[index] = totBuyers[totBuyers.length-1];
        totBuyers.pop();
    }

    function buyEnergy(int energy, address sellerAdd, address buyerAdd) public {
        // seller gives energy to buyer

        if (!buyerApproved()) return;
        record memory transaction;
        transaction.seller = sellerAdd;
        transaction.buyer = buyerAdd;
        transaction.energy = energy;
        p2pTransaction[block.number] = transaction; //recording every transaction corresponding to a block

        //updating accounts of individual seller and buyer
        amtDue[sellerAdd] -= energy*CPrice; 
        amtDue[buyerAdd]  += energy*CPrice; 
    }
    function buyLength() public view returns (uint){
        return totBuyers.length;
    }
    function sellLength() public view returns (uint){
        return totSellers.length;
    }
    function getBuyer(uint index) public view returns (address, int){
        return (totBuyers[index], buyers[totBuyers[index]].energyAmt);
    }   
    function getSeller(uint index) public view returns (address, int){
        return (totSellers[index], sellers[totSellers[index]].energyAmt);
    }   
    function getUserDetail(address userAdd) public view returns (int){
        return amtDue[userAdd];
    }
    function buyerApproved() public pure returns (bool) {
        return true;
    }
}