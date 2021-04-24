// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract P2P {
    struct buyerData {
        address id;
        uint tag;
        uint energyAmt;
    }

    struct sellerData {
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

	// Creating mapping
	mapping (address => uint) result;
	address[] seller_result;
	address[] public sortedArray;
	
	function adding_values(address id, uint bid) public {
        
         bid = result[id];
        seller_result.push(id) ;
  
    }
	
	function sort () public {
    
    /** Loop through the original array to sort it*/
            for (uint i = 0; i < seller_result.length; i++) {
    
    /** Set the mapping to 0 initially. Later on all mapping entries will be the actual index +1.
     ** This is done, because an element larger than all compared elements will keep its 0 mapping
     ** throughout all comparisons and is assigned the new largest index in the end. If the acutal
     ** idexes were used, an element smaller than all others might falsely be assigned the largest
     ** index, because it got through the comparisons with mapping value 0.*/
              //  result[i] = 0;
    
    /** Compare the current element to all items that have already been sorted*/
                for (uint j = 0; j < i; j++){
    
    /** If the item is smaller that the item it is compared against, sort it accordingly.*/
         if (result[seller_result[i]] < result[seller_result[j]]) {
               address temp = seller_result[i];
               seller_result[i] = seller_result[j];
               seller_result[j]=temp;
    
            }
    
    /** Initialize the sortedArray to the same size as the testStructArray. Skip as many entries as
     ** the sortedArray already has, otherwise the sortedArray would double in size each time the
     ** function is called.*/
            uint lengthSortedArray = sortedArray.length;
            for (uint i = 0; i < seller_result.length; i++) {
                if (i < lengthSortedArray) continue;
                sortedArray.push(seller_result[i]);
            }
    /*
    // Go over the testStructArray and copy the items to sortedArray to the positions specified in
      the helper mapping. At this point subtract the added 1, to get the real index 
            for (uint i = 0; i < seller_result.length; i++) {
                sortedArray[result[i]] = seller_result[i];
            }
    */
        }
        
    }   
}

    function sellingPrice(uint requiredEnergy) public view returns (uint) {
        uint n = cutoff.length;
        uint i = 0;
        uint totalEnergy = 0;
        while (i<n && totalEnergy+cutoff[i].energy<=requiredEnergy) {
            totalEnergy += cutoff[i].energy;
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

    function matchBid(uint sellerIndex, uint buyerIndex) public {
        if(sellers.length==0 || buyers.length==0){
            return;
        }
        uint i = buyerIndex; 
        uint j = sellerIndex;
        uint remainder =0; uint calcAmount = 0;
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
