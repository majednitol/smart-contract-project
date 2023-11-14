// SPDX-License-Identifier:GPL-3.0
pragma solidity ^0.8.17;

// onek gula bycyle add kora .. struct mapping
//  buy function
//  list of bycyle

contract Automotive {
    struct Bicycle {
        string name;
        uint256 model;
        uint256 price;
        string color;
        address owner;
    }

    event productsold(
        string name,
        uint256 model,
        uint256 price,
        string color,
        address owner
    );

    mapping(uint256 => Bicycle)  bicycles;

    function addbicycle(
        uint256 productId,
        string memory _name,
        uint256 _model,
        uint256 _price,
        string memory _color
    ) public {
        Bicycle memory newBicycle = Bicycle({
            name: _name,
            model: _model,
            price: _price,
            color: _color,
            owner: msg.sender
        });
        bicycles[productId] = newBicycle;
    }

    function getBicycleList(uint256 productId)
        public
        view
        returns (
            string memory,
            uint256,
            uint256,
            string memory,
            address
        )
    {
        Bicycle memory bicyle = bicycles[productId];
        require(bicyle.owner == msg.sender, "you aren't owner");

        return (
            bicyle.name,
            bicyle.model,
            bicyle.price,
            bicyle.color,
            bicyle.owner
        );
    }

    // function deleteProduct(uint256 productId) public {
    //     bicycles[productId]  == " ";
    // }

    function buyBicycle(
        uint256 productId
       
        
    ) public payable{
        Bicycle memory bicycle = bicycles[productId];
        require(bicycle.owner != msg.sender, "you are owner");
        // require(bicyle.price >= msg.value, "insfuicent balance");
        require(bicycle.price == msg.value, "insuffient balance");
         bicycle.owner == msg.sender;
        payable(bicycle.owner).transfer(bicycle.price);
    
        emit productsold(bicycle.name, bicycle.model, bicycle.price,bicycle.color, bicycle.owner);
    }
}
