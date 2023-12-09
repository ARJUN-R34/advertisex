// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import "./XChild.sol";

contract XFactory {

    // contract address of the AdS Infra Contract
    address public infraContract;

    // array to store the list of all pools
    address[] private _pools;
    // array to store the list of all integrators
    string[] private _integrators;

    // constructor to store the infra contract address
    constructor(address infraContractAddress) {
        infraContract = infraContractAddress;
    }

    // modifier to check if the caller is Infra contract
    modifier isCallerInfra(address caller) {
        require(caller == infraContract, "Unauthorized caller");
        _;
    }

    // store the details of the advertiser
    struct AdvertiserDetails {
        string name; // Name of the advertiser
        string websiteUrl; // URL of the advertiser
        address walletAddress; // wallet address of the advertier
        uint8 priorityPercentage; // priority value the advertiser is willing to pay
        uint256 poolCapital; // advertiser's pool capital
        bool isNsfw; // type of advertiser's content
        string content; // ipfs hash of the advertiser's content
        uint256 minimumTransaction; // minimum transaction amount allowed to consider to show ad
    }

    struct IntegratorDetails {
        string name;
        string websiteUrl;
        string logoUrl;
    }

    // TODO - walletaddress => pooladdress
    mapping (address => address) public getAdvertisersCompany;

    // mapping to store the advertiser's child contract (pool) against advertiser details
    mapping (address => AdvertiserDetails) public advertiserContract;
    // mapping to store the advertiser's wallet address against advertiser details
    mapping (address => AdvertiserDetails) public advertiserData;       // make it private
    mapping (string => IntegratorDetails) public integratorData;


    // can be called from outside
    mapping (string => address[]) public listOfPoolsOfIntegrator;
    mapping (address => string[]) public listOfIntegratorssOfPool;

    // function to get the advertiser data against their wallet address
    function getPoolDetails(address advertiserAddress) isCallerInfra(msg.sender) external view returns (AdvertiserDetails memory) {
        return advertiserData[advertiserAddress];
    }

    // function to get the list of all the pools created
    function getPoolsList() isCallerInfra(msg.sender) external view returns (address[] memory pools) {
        return _pools;
    }

    // function to deploy the advertiser contract
    function deployAdvertiserContract(string calldata _name, string calldata _websiteUrl, address _walletAddress, uint8 _priorityPercentage, uint256 _poolCapital, string calldata _content, uint256 _minimumTransaction, string[] memory listOfIntegrators) external returns (address) {
        advertiserData[_walletAddress].name = _name;
        advertiserData[_walletAddress].websiteUrl = _websiteUrl;
        advertiserData[_walletAddress].walletAddress = _walletAddress;
        advertiserData[_walletAddress].priorityPercentage = _priorityPercentage;
        advertiserData[_walletAddress].poolCapital = _poolCapital;
        advertiserData[_walletAddress].content = _content;
        advertiserData[_walletAddress].minimumTransaction = _minimumTransaction;
        // add for NSFW

        XChild xchildContract = new XChild(msg.sender);

        advertiserContract[address(xchildContract)].name = _name;
        advertiserContract[address(xchildContract)].websiteUrl = _websiteUrl;
        advertiserContract[address(xchildContract)].walletAddress = _walletAddress;
        advertiserContract[address(xchildContract)].priorityPercentage = _priorityPercentage;
        advertiserContract[address(xchildContract)].poolCapital = _poolCapital;
        advertiserContract[address(xchildContract)].isNsfw = _isNsfw;
        advertiserContract[address(xchildContract)].content = _content;
        advertiserContract[address(xchildContract)].minimumTransaction = _minimumTransaction;

        listOfIntegratorssOfPool[address(xchildContract)] = listOfIntegrators;

        for(uint8 i=0; i<listOfIntegrators.length ; i++) {
            address[] storage dummyArray = listOfPoolsOfIntegrator[listOfIntegrators[i]];
            dummyArray.push(address(xchildContract)); 
            listOfPoolsOfIntegrator[listOfIntegrators[i]] = dummyArray;
        }

        _pools.push(address(xchildContract));

        return address(xchildContract);
    }

// function to get the advertiser data against their wallet address
    function getIntegratorDetails(string calldata integratorName) isCallerInfra(msg.sender) external view returns (IntegratorDetails memory) {
        return integratorData[integratorName];
    }

    function addIntegrator(string calldata name, string calldata websiteUrl, string calldata logoUrl) external {
        require(keccak256(abi.encodePacked(integratorData[name].name)) == keccak256(abi.encodePacked('')), "Already registered");

        integratorData[name].name = name;
        integratorData[name].websiteUrl = websiteUrl;
        integratorData[name].logoUrl = logoUrl;

        _integrators.push(name);
    }

    function getIntegratorsList() isCallerInfra(msg.sender) external view returns (string[] memory) {
        return _integrators;
    }

    function getAdDetails(string calldata walletName) isCallerInfra(msg.sender) external view returns(string memory){
        address poolAddress = listOfPoolsOfIntegrator[walletName][0];
        return advertiserContract[poolAddress].content;
    }

}