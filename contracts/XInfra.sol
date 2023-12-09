// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

interface XFactory {
    function getPoolsList() external view returns (address[] memory pools);
    function getIntegratorsList() external view returns (string[] memory);
    function getAdDetails(string calldata walletName) external view returns(string memory);
}

contract XInfra {

    address private _factoryContractAddress;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // modifier to check if the caller is Infra contract
    modifier isOwner(address caller) {
        require(caller == owner, "Unauthorized caller, only owner can call");
        _;
    }

    function setFactoryContract(address factoryContract) isOwner(msg.sender) public{
        _factoryContractAddress = factoryContract;
    } 

    function transferOwnership(address newOwner) isOwner(msg.sender) public{
        owner = newOwner;
    } 

    // function to get the advertiser data against their wallet address
    function getPoolsList() external view returns (address[] memory ) {
        XFactory factoryContract = XFactory(_factoryContractAddress);

        address[] memory pools = factoryContract.getPoolsList();

        return pools;
    }

    // function to get the advertiser data against their wallet address
    function getIntegratorsList() external view returns (string[] memory) {
        XFactory factoryContract = XFactory(_factoryContractAddress);

        string[] memory integrators = factoryContract.getIntegratorsList();

        return integrators;
    }

    // function to get the advertiser data against their wallet address
    function getAdDetails(string calldata walletName) external view returns (string memory ) {
        XFactory factoryContract = XFactory(_factoryContractAddress);

        string memory adDetails = factoryContract.getAdDetails(walletName);

        return adDetails;
    }

}