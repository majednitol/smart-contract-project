// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract BankingContract {
    struct Accountholder {
        string name;
        address  accountAddress;
        uint256 balance;
        bool access;
    }
    mapping(address => Accountholder) public AccountholderDetails;
    address[]  public AllAccountholderDetails;

    address payable owner;

    event Accountholderinformation(string name, address accountAddress);

    constructor() public {
        owner = payable(msg.sender);
    }

    function creteAccount(string memory _name) public payable {
        Accountholder memory newholder = Accountholder({
            name: _name,
            accountAddress: msg.sender,
            balance: msg.value,
            access: false
        });

        AccountholderDetails[msg.sender] = newholder;
        AllAccountholderDetails.push(msg.sender);
        emit Accountholderinformation(_name, msg.sender);
    }

    function getAccountholderDetails(address user)
        public
        view
        returns (
            string memory,
            address ,
            uint256,
            bool 
        )
    {
        Accountholder memory x = AccountholderDetails[user];
        return (x.name, x.accountAddress, x.balance, x.access);
    }

    function deposit() public payable {
        require(
            AccountholderDetails[msg.sender].accountAddress == msg.sender,
            "this account doesnot exsit "
        );
        require(
            msg.sender == owner ||
                AccountholderDetails[msg.sender].access == true,
            " only owner and  deposit his money"
        );
        require(msg.value > 0, "deposit amount must be greter than 0");
        AccountholderDetails[msg.sender].balance += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(
            msg.sender == owner ||
                AccountholderDetails[msg.sender].access == true,
            " only owner and   withdraw his money"
        );
        require(
            amount <= AccountholderDetails[msg.sender].balance,
            " insufficient  funds"
        );
        require(amount > 0, "withdraw amount must be greter than 0");
        payable(msg.sender).transfer(amount);
        AccountholderDetails[msg.sender].balance -= amount;
    }

    function transferMoney(address payable recipient, uint256 amount)
        public
        payable
    {
        require(
            amount <= AccountholderDetails[msg.sender].balance,
            "insuffient amout"
        );
        require(amount > 0, "transfer amount  must be greter than 0");
        AccountholderDetails[recipient].balance += amount;
        AccountholderDetails[msg.sender].balance -= amount;
    }

    function getBalance() public view returns (uint256) {
        return AccountholderDetails[msg.sender].balance;
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "only owner have grant access");
        // owner = user;
        AccountholderDetails[user].access = true;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "only owner can revoke access");
        AccountholderDetails[user].access = false;
    }

    function destroy() public {
        require(msg.sender == owner, "only owner can destroy the contract");
        selfdestruct(owner);
    }
}
