pragma solidity ^0.5.0;

/**
* @title Interface that token factory should implement
*/
contract ITokensFactory {
    /**
    * @notice This function create new token depending on his standard
    * @param name Name of the future token
    * @param symbol Symbol of the future token
    * @param decimals The quantity of the future token decimals
    * @param totalSupply The number of coins
    * @param tokenStandard Identifier of the token standard
    */
    function createToken(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint totalSupply,
        bytes32 tokenStandard
    ) 
        public;

    /**
    * @notice This function load new token strategy to the token factory
    * @param tokenStrategy Address of the strategy contract
    */
    function addTokenStrategy(address tokenStrategy) public;

    /**
    * @notice Remove strategy from tokens factory
    * @param standard Token standard which will be removed
    */
    function removeTokenStrategy(bytes32 standard) public;

    /**
    * @notice Update strategy in tokens factory
    * @param standard Token standard which will be updated on the new strategy
    * @param newAddress New strategy address
    */
    function updateTokenStrategy(bytes32 standard, address newAddress) public;

    /**
    * @notice Returns standards list length
    */
    function getSupportedStandardsLength() public view returns (uint);

    /**
    * @notice Returns standard of the registered token 
    * @param tokenAddress Address of registered token
    */
    function getTokenStandard(address tokenAddress) public view returns (bytes32);

    /**
    * @notice Returns token issuer address
    * @param token Token address
    */
    function getIssuerByToken(address token) public view returns (address);

    /**
    * @notice Verification of the supported tokens standards in the tokens factory
    * @param standard A standard for verification
    */
    function isSupported(bytes32 standard) public view returns (bool);
}