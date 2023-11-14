//SPDX-License-Indetifier:GPL-3.0
pragma solidity ^0.8.17;

contract CryptoExchange {
 struct ExchangeCompany{
     address owner;
      uint256 amount;
        uint256 price;
        uint256 balance;
 }

 mapping(address=>ExchangeCompany) public exchangeCompany;
    struct Order {
        address trader;
        uint256 tradeId;
        uint256 amount;
        uint256 price;
        uint256 totalPrice;
        bool isBuy;
        uint256 balance;

    }
    
    mapping(address => mapping(uint256 => Order)) public orders;
    // mapping(address=>uint256) public balances;
    // mapping(uint256 => bool) public traded;

    
    uint256 public fee = 0.1 ether;
    address public owner;
   
    // event Buy(address  buyer, uint256  tradeId, uint256 amount, uint256 price);
    // event Sell(address  seller, uint256  tradeId, uint256 amount, uint256 price);

    constructor(uint256 _price, uint256 _amount) {
        owner= msg.sender;
        
      ExchangeCompany storage x =   exchangeCompany[owner];
     x.owner = owner;
    x.amount = _amount;
     x.price= _price;
     x.balance = _amount * _price;
    }
    // uint256 amount;
    uint256 price;

    function createTrader(uint256 tradeId) public payable {
        uint256 amount;

        orders[msg.sender][tradeId] = Order({
            trader: msg.sender,
            tradeId: tradeId,
            amount:0,
            price: 0,
            totalPrice:amount*price,
            balance:msg.value,
            isBuy: true
        });

        // emit Buy(msg.sender, tradeId, amount, price);

        
    }

    function sell(uint256 tradeId) public payable {
        ExchangeCompany memory ex=   exchangeCompany[owner];
         Order memory x =  orders[msg.sender][tradeId];
        
        require(orders[msg.sender][tradeId].amount!=0, "you don't have this amount of crypto");
              
        
    //  Order storage s = orders[seller][tradeId];
     ex.amount += x.amount;
     ex.balance += x.amount*x.price;
    //  ex.balance -= x.totalPrice;

 x.amount = 0;
 x.price= 0;
//  x.totalPrice = 0;
x.balance +=x.totalPrice;
}
function cancel(uint256 tradeId) public {
        require(orders[msg.sender][tradeId].trader == msg.sender, "Trade not found");
    
        orders[msg.sender][tradeId].amount = 0;

    }
    
    
    function setFee(uint256 _fee) public {
         ExchangeCompany memory x=   exchangeCompany[owner];
        x.owner = msg.sender;
        require(msg.sender == x.owner, "Only owner can set fee");
        fee = _fee;
    }

    function buy(uint256 tradeId,uint256 _amount) public {
         ExchangeCompany memory x =   exchangeCompany[owner];
        Order memory order = orders[msg.sender][tradeId];
        require(x.amount>_amount,"this amount supply not aviable");
        require(order.trader== msg.sender, "Trader not found");
        // require(!traded[tradeId], "Trade already executed");

        uint256 tradeValue = _amount * price;
        uint256 tradeFee = tradeValue * fee / 100;

        if (order.isBuy) {
            require(orders[msg.sender][tradeId].balance >= tradeValue + tradeFee, "Insufficient balance");
          order.amount = _amount;
        
     
        x.amount -= _amount;
            orders[msg.sender][tradeId].balance -= (tradeValue + tradeFee);
            exchangeCompany[owner].balance += (tradeValue + tradeFee);
        } 

       
        // traded[tradeId] = true;
        // payable(owner).transfer(tradeFee);
        // payable(order.trader).transfer(tradeValue - tradeFee);
    }

    function deposit(uint256 tradeId) public payable{
   require(msg.value>0,"plz deposit greater than 0");
   require(orders[msg.sender][tradeId].trader==msg.sender,"you are not trade owner");
   orders[msg.sender][tradeId].balance += msg.value;

    }
     function withdraw(uint256 tradeId, uint256 amount) public payable{
   require(orders[msg.sender][tradeId].balance>0,"plz withdraw greater than 0");
   require(orders[msg.sender][tradeId].trader==msg.sender,"you are not trade owner");
payable(msg.sender).transfer(amount);
   orders[msg.sender][tradeId].balance -= amount;

    }

 function balances(uint256 tradeId) public view returns(uint256){
    return orders[msg.sender][tradeId].balance; 
 }
}