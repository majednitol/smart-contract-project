// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

contract TodoList {
    uint  public _idUser;
    address public ownerOfContract;
    address[] public creators;
    string[] public message;
    uint256[] public messageId;

    struct TodoListApp {
        address account;
        uint256 userId;
        string message;
        bool completed;
    }
    event TodoEvent(
        address indexed account,
        uint256 indexed userId,
        string message,
        bool completed
    );
    mapping(address => TodoListApp) public todoListApps;

    constructor() {
        ownerOfContract = msg.sender;
    }
  

    function inc() internal {
        _idUser++;
    }

    function createList(string calldata _message) external {
        inc();
        uint256 idNumber = _idUser;

        TodoListApp memory toDo =  TodoListApp({
            account : msg.sender,
        userId : idNumber,
        message : _message,
        completed : false
        });
        toDo.account = msg.sender;
        toDo.userId = idNumber;
        toDo.message = _message;
        toDo.completed = false;
        
        message.push(_message);
        bool isPresent = false;
    for (uint i = 0; i < creators.length; i++) {
        if (creators[i] == msg.sender) {
            isPresent = true;
            break;
        }
    }
    if (!isPresent) {
        creators.push(msg.sender);
    }
        messageId.push(idNumber);
        todoListApps[msg.sender]= toDo;
        
        emit TodoEvent(msg.sender, idNumber, _message, toDo.completed);
    }

    function getCreatorData(
        address _address
    ) public view returns (address, uint256, string memory, bool) {
        TodoListApp memory singleUserData = todoListApps[_address];
        return (
            singleUserData.account,
            singleUserData.userId,
            singleUserData.message,
            singleUserData.completed
        );
    }

    function getAddress() public view returns (address[] memory) {
        return creators;
    }

    function getMessage() public view returns (string[] memory) {
        return message;
    }

    function toggle(address _creator) public  {
        TodoListApp storage singleUserData = todoListApps[_creator];
        singleUserData.completed = !singleUserData.completed;
    }
    
}



