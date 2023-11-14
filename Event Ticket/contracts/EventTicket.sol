// SPDX-License-Identifier:UNLICENSE
pragma solidity ^0.8.17;
contract EventTicket{
  
    uint  numberOfTicket;
    uint  ticketPrice;
    uint  startAt;
    uint  endAt;
    uint  timeRange;
    uint  totalAmount;
    string  message= "buy you first EVENT ticket";

    constructor(uint _ticketPrice){
        ticketPrice = _ticketPrice;
        startAt = block.timestamp;
        endAt = block.timestamp + 7 days;
        timeRange= (endAt - startAt)/60/60/24;

    }

    function buyTicket (uint value) public  returns (uint ticketId){
     require(ticketPrice==value,"plz enter real price");
     numberOfTicket++;
     totalAmount +=value;
    ticketId = numberOfTicket;


}


    function getTotalAmount () public view returns(uint ){
        return totalAmount;
    }

}