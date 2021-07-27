pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        
        //low level function to send extra gas for more processing
        //be careful to check the bool return value to ensure low level call was successful
        (bool success, ) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "The transaction wasn't successful, cancelling");
    }
    
    fallback() external {
        
    }
}