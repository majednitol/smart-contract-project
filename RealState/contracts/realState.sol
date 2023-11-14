// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract RealState {
    struct Property {
        uint256 price;
        string name;
        string description;
        string location;
        bool forSale;
        address owner;
    }

    mapping(uint256 => Property) public properties;
    uint256[] public propertyIds;
    event propertySold(uint256 propertyId);
 
    function getProperty(uint256 propertyId)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            string memory,
            bool,
            address
        )
    {
        Property memory property = properties[propertyId];
        require(property.owner == msg.sender, "you aren't  owner");
        return (
            property.price,
            property.name,
            property.description,
            property.location,
            property.forSale,
            property.owner
        );
    }

    function listPropertyForSale(
        uint256 _propertyId,
        uint256 _price,
        string memory _name,
        string memory _description,
        string memory _location
    ) public {
        Property memory newProperty = Property({
            price: _price,
            name: _name,
            description: _description,
            forSale: true,
            owner: msg.sender,
            location: _location
        });

        properties[_propertyId] = newProperty;
        propertyIds.push(_propertyId);
    }

    function buyProperty(uint256 propertyId) public payable {
        Property memory property = properties[propertyId];
        require(property.owner != msg.sender, "you are owner");
        require(property.price == msg.value, "insuffient balance");
        require(property.forSale, "Property isn't for sale");
        property.forSale = false;
        property.owner = msg.sender;

        payable(property.owner).transfer(property.price);
        emit propertySold(propertyId);
    }
}



