// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract P2P {
    struct buyerData {
        address id;
        uint tag;
        uint energyAmt;       
    }
   
    struct sellerData{
        address id;
        uint tag;
        uint bid;
        uint energyAmt;
       
    }
    struct pair {
        uint price;
        uint energy;
    }
    pair[] cutoff;
   
    sellerData[] sellers;
    buyerData[] buyers;
   
    function seller(sellerData memory requester) public {
        sellers.push(requester);
        pair memory cutoffInfo;
        cutoffInfo.price = requester.bid;
        cutoffInfo.energy = requester.energyAmt;
        cutoff.push(cutoffInfo);
    }
   
    function buyer(buyerData memory requester) public {
        buyers.push(requester);
    }
   
    function sellingPrice(uint requiredEnergy) public view returns (uint){
        uint n = cutoff.length;
        uint i = 0;
        uint totalEnergy = 0;
        while (i<n && totalEnergy+cutoff[i].energy<=requiredEnergy) {
            totalEnergy += cutoff[i].price;
            i++;
        }
        return cutoff[i-1].price;
    }
    
    function clearMarket() public {
        
        uint i=0;
        uint j=0;
        
    
        for(i=0;i<buyers.length;i++)
        {
           for(j=0;j<sellers.length;j++) 
           {
               if(buyers[i].tag==sellers[j].tag)
               matchBid(j,i);
           }
        }
        
        if (sellers.length>0 && buyers.length>0){
             for (i=0;i<buyers.length;i++){
                for (j=0;j<sellers.length;j++){
                    if (buyers[i].tag == sellers[j].tag+1 || buyers[i].tag+1 == sellers[j].tag)
                        matchBid(j,i);
                }
             }
        }
        
         
        if (sellers.length>0 && buyers.length>0){
             for (i=0;i<buyers.length;i++){
                for (j=0;j<sellers.length;j++){
                    if (buyers[i].tag == sellers[j].tag+2 || buyers[i].tag+2 == sellers[j].tag)
                        matchBid(j,i);
                }
             }
        }
    }
    function matchBid(uint buyerIndex, uint SellerIndex) public {
        if(sellers.length==0 || buyers.length==0){
            return;
        }
        uint i = buyerIndex; 
        uint j = SellerIndex;
        uint remainder =0; uint calcAmount = 0;
        if(sellers[j].energyAmt ==0  || buyers[i].energyAmt==0){
            return;
        }
        if((sellers[j].energyAmt - buyers[i].energyAmt)>=0){
            remainder = sellers[j].energyAmt - buyers[i].energyAmt ;
            calcAmount = sellers[j].energyAmt - remainder ;
            buyEnergy(calcAmount, buyers[j],sellers[i]);
            sellers[j].energyAmt = remainder;
            if(remainder==0){
                removeSeller(j);
            }
            removeBuyer(i);
        }
        else {
            remainder = buyers[i].energyAmt - sellers[j].energyAmt;
            calcAmount = buyers[i].energyAmt - remainder;
            buyEnergy(calcAmount, buyers[j],sellers[i]);
            buyers[j].energyAmt = remainder;
            if(remainder==0){
                removeBuyer(i);
            }
            removeSeller(j);
        }
    }

    function removeSeller(uint index) public {
        require(index < sellers.length, "inappropriate call");
        sellers[index] = sellers[sellers.length-1];
        sellers.pop();
    }

    

    function removeBuyer(uint index) public {
        require(index < buyers.length, "inappropriate call");
        buyers[index] = buyers[buyers.length-1];
        buyers.pop();
    }

    function buyEnergy(uint amount, buyerData memory Buyer, sellerData memory Seller) public{
        //
    }
}