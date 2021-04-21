pragma solidity ^0.8;

import "./ItemManager.sol";

contract Item {
    uint public priceInWei;
    uint public paidWei;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index){
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        index = _index;
    }

    receive() external payable {
        require(priceInWei == msg.value, "we do not support partial payments");
        require(paidWei == 0, "item is already paid");
        paidWei += msg.value;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Delivery did not work");
    }
}