pragma solidity ^0.8.0;

contract VotingSystem {
address public owner;

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
        uint age;
        address Caddress;
    }
struct Voter {
        string name;
        address Caddress;
        uint age;
        
    }

    constructor(){
owner = msg.sender;
    }
    // Array of candidates
    address[] public candidatesAddress;
    // mapping(address=>Candidate) public pendingRegisterCandidate;
     mapping(address=>Candidate) public RegisterCandidate; // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
 mapping(address=>Voter) public RegisterVoter;


    // Mapping to keep track of who has voted
    mapping(address => bool) public voters;

    // Event to notify when a vote is cast
    event VoteCast(address  voter);

   
function submitCandidateData(string memory _name,uint _age ) public{
    require(RegisterCandidate[msg.sender].Caddress!=msg.sender,"you are already registed");
     Candidate memory candid = Candidate({
            name: _name,
            age:_age,
            Caddress:msg.sender,
            voteCount:0
            
        });

        RegisterCandidate[msg.sender] = candid;
        candidatesAddress.push(msg.sender);
       
}

function submitVoterData(string memory _name,uint _age ) public{
    require(RegisterVoter[msg.sender].Caddress!=msg.sender,"you are already registed");
    require(_age>=18,"you are child");
     Voter memory voter = Voter({
            name: _name,
            age:_age,
            Caddress:msg.sender
            
        });

       RegisterVoter[msg.sender] = voter;
       
}


    // Function to cast a vote for a candidate
    function vote(uint CandidateNumber) public {
        

        require(!voters[msg.sender], "You have already voted");

        RegisterCandidate[candidatesAddress[CandidateNumber]].voteCount++;
        voters[msg.sender] = true;

        emit VoteCast(msg.sender);
    }

    // Function to get the total number of votes cast
    function getTotalVotes() public view returns (uint256) {
        require(msg.sender==owner,"you are not perform this action");
        uint256 totalVotes = 0;
        for (uint256 i = 0; i < candidatesAddress.length; i++) {
            Candidate memory x = RegisterCandidate[candidatesAddress[i]];
            totalVotes += x.voteCount;
        }
        return totalVotes;
    }

    // Function to get the winner of the election
    function getWinner() public view returns (string memory) {
         require(msg.sender==owner,"you are not perform this action");
        uint256 winningVoteCount = 0;
        address winningCandidate;

        for (uint256 i = 0; i < candidatesAddress.length; i++) {
            Candidate memory x = RegisterCandidate[candidatesAddress[i]];
            
            if (x.voteCount > winningVoteCount) {
                winningVoteCount = x.voteCount;
                winningCandidate = candidatesAddress[i];
            }
        }

        return RegisterCandidate[winningCandidate].name;
    }
}
