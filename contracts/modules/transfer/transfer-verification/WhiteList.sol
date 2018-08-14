pragma solidity 0.4.24;

import "../../../interfaces/IWhiteList.sol";
import "../../../interfaces/ITokensFactory.sol";

/**
* @title Whitelist service
*/
contract WhiteList is IWhiteList {
    // Address of the tokens factory
    address public tokenFactory;

    // Declare storage for a whitelisted addresses
    mapping(address => mapping(address => bool)) whitelistedAddresses;

    /**
    * @notice Write info to the log when someone was added to the whitelist
    * @param tokenAddress Address of the token
    * @param who An address which was added to the Whitelist
    */
    event Added(address who, address tokenAddress);

    /**
    * @notice Write info to the log when someone was removed from the whitelist
    * @param tokenAddress Address of the token
    * @param who An address which was removed from the Whitelist
    */
    event Removed(address who, address tokenAddress);

    /**
    * @notice Setting address of the tokens factory
    * @param _tokensFactory Address of the tokens factory
    */
    constructor(address _tokensFactory) public {
        tokenFactory = _tokensFactory;
    }

    /**
    * @notice Werify address in the whitelist
    * @param who Address to be verified
    * @param tokenAddress Address of the token
    */
    function presentInWhiteList(address who, address tokenAddress) public view returns (bool) {
        return whitelistedAddresses[tokenAddress][who];
    }

    /**
    * @notice Add address to the whitelist
    * @param who Address which will be added
    * @param tokenAddress Token for address attachment
    */
    function addToWhiteList(address who, address tokenAddress) public {
        require(who != address(0), "Invalid customer address.");
        require(ITokensFactory(tokenFactory).getTokenStandard(tokenAddress).length != 0, "Token is not registered in the tokens factory.");

        whitelistedAddresses[tokenAddress][who] = true;

        emit Added(who, tokenAddress);
    }

    /**
    * @notice Add address to the whitelist
    * @param who Address which will be added
    * @param tokenAddress Token address
    */
    function removeFromWhiteList(address who, address tokenAddress) public {
        require(who != address(0), "Invalid customer address.");
        require(ITokensFactory(tokenFactory).getTokenStandard(tokenAddress).length != 0, "Token is not registered in the tokens factory.");

        whitelistedAddresses[tokenAddress][who] = false;

        emit Removed(who, tokenAddress);
    }
}