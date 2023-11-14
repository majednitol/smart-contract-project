// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MedicalData {
    struct Patient {
        string patientID;
        string name;
        string gender;
        uint256 age;
        string bloodGroup;
        string location;
        Parent parent;
        bool isAdded;
        string[] data;
    }

    struct Parent {
        string parentID;
        string name;
        int256 parentIDNumber;
        uint256 phoneNumber;
        string NIDInfo;
        bool isAdded;
        string[] data;
    }

    mapping(address => Patient) private patients;
    mapping(address => Parent) private parents;
    mapping(address => mapping(address => bool)) accessList;
    address[] public allPatientsAddress;

    function addPatient(
        address patientAddress,
        string memory patientID,
        string memory name,
        string memory gender,
        uint256 age,
        string memory bloodGroup,
        string memory location,
        string memory parentID,
        string memory parentName,
        int256 parentIDNumber,
        uint256 parentPhoneNumber,
        string memory parentNIDInfo
    ) external {
        require(!patients[patientAddress].isAdded, "Patient already exists");
        require(patientAddress != address(0), "Invalid patient address");

        Patient storage patient = patients[patientAddress];
        patient.patientID = patientID;
        patient.name = name;
        patient.gender = gender;
        patient.age = age;
        patient.bloodGroup = bloodGroup;
        patient.location = location;
        patient.isAdded = true;

        Parent storage parent = parents[patientAddress];
        parent.parentID = parentID;
        parent.name = parentName;
        parent.parentIDNumber = parentIDNumber;
        parent.phoneNumber = parentPhoneNumber;
        parent.NIDInfo = parentNIDInfo;
        parent.isAdded = true;

        allPatientsAddress.push(patientAddress);
    }

    function getPatient(address patientAddress)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256,
            string memory,
            string memory,
            string memory,
            string memory,
            int256,
            uint256,
            string memory
        )
    {
        Patient storage patient = patients[patientAddress];
        Parent storage parent = parents[patientAddress];

        require(patient.isAdded, "Patient not found");

        return (
            patient.patientID,
            patient.name,
            patient.gender,
            patient.age,
            patient.bloodGroup,
            patient.location,
            parent.parentID,
            parent.name,
            parent.parentIDNumber,
            parent.phoneNumber,
            parent.NIDInfo
        );
    }
}
