// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

interface Paymaster {
    // function definition of the paymaster deposit function
    function depositFor(address paymasterId) external payable;
}

contract XChild {

    // contract address of the AdS Infra Contract
    address public owner;
    // contract address of the AdS Wallet
    address private immutable AdSWallet = 0x71296b2ACbFDd24dD1dd089cdAe8708BfD8cB738;
    // contract address of the paymaster wallet
    // create our own paymaster
    address private immutable paymasterAddress = 0x00000f79B7FaF42EEBAdbA19aCc07cD08Af44789;

    // constructor to store the infra contract address
    constructor(address deployer) {
        owner = deployer;
    }

    // modifier to check if the caller is Infra contract
    modifier isOwner(address caller) {
        require(caller == owner, "Unauthorized caller");
        _;
    }

    // function to get the verifier address
    function getVerifier() external view returns (address) {
        return AdSWallet;
    }

    fallback() external payable {
        Paymaster paymasterContract = Paymaster(paymasterAddress);

        paymasterContract.depositFor{value: msg.value}(AdSWallet);
    }

    receive() external payable {
        Paymaster paymasterContract = Paymaster(paymasterAddress);

        paymasterContract.depositFor{value: msg.value}(AdSWallet);
    }

}