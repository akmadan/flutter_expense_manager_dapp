// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ExpenseManagerContract {
    address public owner;

    event Deposit(
        address indexed _from,
        uint _amount,
        string _reason,
        uint _timestamp
    );
    event Withdrawal(
        address indexed _to,
        uint _amount,
        string _reason,
        uint _timestamp
    );

    struct Transaction {
        address user;
        uint amount;
        string reason;
        uint timestamp;
    }

    mapping(address => uint) public balances;
    Transaction[] public transactions;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can call this function"
        );
        _;
    }

    function deposit(uint _amount, string memory _reason) public payable {
        require(_amount > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }

    function withdraw(uint _amount, string memory _reason) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount, _reason, block.timestamp);
    }

    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }

    function getTransactionsCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(
        uint _index
    ) public view returns (address, uint, string memory, uint) {
        require(
            _index < transactions.length,
            "Transaction index out of bounds"
        );
        Transaction memory transaction = transactions[_index];
        return (
            transaction.user,
            transaction.amount,
            transaction.reason,
            transaction.timestamp
        );
    }

    function getAllTransactions()
        public
        view
        returns (
            address[] memory,
            uint[] memory,
            string[] memory,
            uint[] memory
        )
    {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory reasons = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);

        for (uint i = 0; i < transactions.length; i++) {
            users[i] = transactions[i].user;
            amounts[i] = transactions[i].amount;
            reasons[i] = transactions[i].reason;
            timestamps[i] = transactions[i].timestamp;
        }

        return (users, amounts, reasons, timestamps);
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
