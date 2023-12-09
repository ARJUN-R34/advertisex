// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

interface XFactory {
    function getPoolsList() external view returns (address[] memory pools);
    function getIntegratorsList() external view returns (string[] memory);
    function getAdDetails(string calldata walletName) external view;
}

contract XInfra {

    address private _factoryContractAddress;

    constructor(address factoryContract) {
        _factoryContractAddress = factoryContract;
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
    function getAdDetails() external view returns (string[] memory ) {
        XFactory factoryContract = XFactory(_factoryContractAddress);

        // string[] memory integrators = factoryContract.getAdDetails();

        // return integrators;
    }

}
