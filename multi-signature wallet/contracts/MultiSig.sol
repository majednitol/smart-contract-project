// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract MultiSig {
    address[] public owners;
    uint256 public numConfirmationsRequired;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
    }
    mapping(uint256 => mapping(address => bool)) isConfirmed;
    Transaction[] public transactions;
    event TransactionSubmitted(
        uint256 transactionId,
        address sender,
        address receiver,
        uint256 amount
    );
    event TransactionConfirmed(uint256 transactionId);
    event TransactionExecuted(uint256 transactionId);

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 1, "Owners require must be greter than 1");
        require(
            _numConfirmationsRequired > 0 &&
                numConfirmationsRequired <= _owners.length,
            "Num of confimations  are not in snyc with the number of owners"
        );
        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid Owner");
            owners.push(_owners[i]);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    function submitTransaction(address _to) public payable {
        require(_to != address(0), "Invalid Receiver's address");
        require(msg.value > 0, "Transfer amount must be geater than 0");
        uint256 transactionId = transactions.length;
        transactions.push(
            Transaction({to: _to, value: msg.value, executed: false})
        );
        emit TransactionSubmitted(transactionId, msg.sender, _to, msg.value);
    }

    function confirmTransaction(uint256 _transactionId) public {
        require(_transactionId < transactions.length, "Invaild Transaction Id");
        require(
            !isConfirmed[_transactionId][msg.sender],
            "Transaction is already confirmed by the owner"
        );
        isConfirmed[_transactionId][msg.sender] = true;
        emit TransactionConfirmed(_transactionId);
        if (isTransactionConfirmed(_transactionId)) {
            executedTransaction(_transactionId);
        }
    }

    function executedTransaction(uint256 _transactionId) public payable {
        require(_transactionId < transactions.length, "Invaild Transaction Id");
        require(
            !transactions[_transactionId].executed,
            "Transaction is already executed"
        );
        //transactions[_transactionId].executed= true;
        (bool success, ) = transactions[_transactionId].to.call{
            value: transactions[_transactionId].value
        }("");
        require(success, "Transaction Executed Failed");
        transactions[_transactionId].executed = true;

        emit TransactionExecuted(_transactionId);
    }

    function isTransactionConfirmed(uint256 _transactionId)
        public
        view
        returns (bool)
    {
        require(_transactionId < transactions.length, "Invaild Transaction Id");
        uint256 confirmationCount;
        for (uint256 i = 0; i < owners.length; i++) {
            if (isConfirmed[_transactionId][owners[i]]) {
                confirmationCount++;
            }
        }
        return confirmationCount >= numConfirmationsRequired;
    }
}
