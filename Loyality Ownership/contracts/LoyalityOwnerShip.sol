// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract LoyaltyOwnership {
    address payable public owner;
    string public poemOrSong;
    uint256 public royaltyPercentage;
    uint256 public term;
    bool public isActive;
    uint256 royaltyDistributionInterval;
    mapping(address => bool) public licensees;
    mapping(address => uint256) public licenseeRoyalties;
    address[] public addressList;
 mapping(address => bool) public pendingLicensees;
    event LicenseeAdded(address indexed licensee);
    event LicenseeRemoved(address indexed licensee);
    event RoyaltiesPaid(address indexed licensee, uint256 royalties);
    event ContractTerminated();

    constructor(
        string memory _poemOrSong,
        uint256 _royaltyPercentage,
        uint256 _term
    ) {
        owner = payable(msg.sender);
        poemOrSong = _poemOrSong;
        royaltyPercentage = _royaltyPercentage;
        term = _term;
        isActive = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier onlyLicensee() {
        require(
            licensees[msg.sender],
            "Only a licensee can perform this action."
        );
        _;
    }

    function addLicensee(address licensee) public onlyOwner {
        licensees[licensee] = false;
        emit LicenseeAdded(licensee);
    }

    function removeLicensee(address licensee) public onlyOwner {
        licensees[licensee] = false;
        licenseeRoyalties[licensee] = 0;
        emit LicenseeRemoved(licensee);
    }

    function payRoyalties() public onlyOwner {
        require(isActive, "The contract is not active.");
        uint256 totalRevenue = address(this).balance;
        uint256 totalRoyalties = (totalRevenue * royaltyPercentage) / 100;
        require(totalRoyalties > 0, "No royalties to distribute.");
        for (uint256 i = 0; i < addressList.length; i++) {
            address licensee = addressList[i];
            uint256 licenseeRevenue = licenseeRoyalties[licensee];
            uint256 licenseeRoyalty = (licenseeRevenue * royaltyPercentage) /
                100;
            licenseeRoyalties[licensee] = 0;
            if (licenseeRoyalty > 0) {
                payable(licensee).transfer(licenseeRoyalty);
                emit RoyaltiesPaid(licensee, licenseeRoyalty);
            }
        }
    }

    function terminateContract() public onlyOwner {
        isActive = false;
        payRoyalties();
        selfdestruct(owner);
        emit ContractTerminated();
    }

    receive() external payable {
        require(isActive, "The contract is not active.");
        require(
            licensees[msg.sender],
            "Only a licensee can pay for the poem or song."
        );
        uint256 licenseeRevenue = licenseeRoyalties[msg.sender] + msg.value;
        licenseeRoyalties[msg.sender] = licenseeRevenue;
    }

    

    // function requestLicenseeApproval() public {
    //     require(!licensees[msg.sender], "You are already a licensee.");
    //     require(
    //         !pendingLicensees[msg.sender],
    //         "You have already requested approval."
    //     );
    //     pendingLicensees[msg.sender] = true;
    // }

    // function approveLicensee(address licensee) public onlyOwner {
    //     require(
    //         pendingLicensees[licensee]==true,
    //         "Licensee has not requested approval."
    //     );
    //     licensees[licensee] = true;
    //     pendingLicensees[licensee] = false;
    //     emit LicenseeAdded(licensee);
    // }

    // function rejectLicensee(address licensee) public onlyOwner {
    //     require(
    //         pendingLicensees[licensee],
    //         "Licensee has not requested approval."
    //     );
    //     pendingLicensees[licensee] = false;
    //     emit LicenseeRemoved(licensee);
    // }

    uint256 public lastRoyaltyDistribution;

    // function setRoyaltyDistributionInterval(uint256 interval) public onlyOwner {
    //     lastRoyaltyDistribution = block.timestamp;
    //     royaltyDistributionInterval = interval;
    // }








    

    // function distributeRoyalties() public onlyOwner {
    //     require(isActive, "The contract is not active.");
    //     uint256 timeSinceLastDistribution = block.timestamp -
    //         lastRoyaltyDistribution;
    //     require(
    //         timeSinceLastDistribution >= royaltyDistributionInterval,
    //         "Not enough time has passed since the last distribution."
    //     );
    //     lastRoyaltyDistribution = block.timestamp;
    //     // distribute royalties as before
    // }

    // function getLicenseeRoyalty(address licensee)
    //     public
    //     view
    //     onlyLicensee
    //     returns (uint256)
    // {
    //     return licenseeRoyalties[licensee];
    // }

    function getLicenseeRevenue()
        public
        view
        onlyLicensee
        returns (uint256)
    {
        return (address(this).balance * royaltyPercentage) / 100;
    }
}
