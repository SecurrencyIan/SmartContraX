pragma solidity ^0.5.0;

/**
* @title Symbol Registry interface
*/
contract ISymbolRegistry {
    /**
    * @notice Register new symbol in the registry
    * @param symbol Symbol
    * @param issuerName Name of the issuer
    */
    function registerSymbol(bytes memory symbol, bytes memory issuerName) public;

    /**
    * @notice Renew symbol
    * @param symbol Symbol which will be renewed
    */
    function renewSymbol(bytes memory symbol) public;

    /**
    * @notice Create request on the symbol ownership transferring
    * @param symbol Symbol
    * @param newOwner Address of the new symbol owner
    */
    function transferOwnership(bytes memory symbol, address newOwner) public;

    /**
    * @notice Accept symbol ownership
    * @param symbol Symbol
    * @param issuerName Name of the issuer
    */
    function acceptSymbolOwnership(bytes memory symbol, bytes memory issuerName) public;

    /**
    * @notice Checks symbol in system 
    * @param symbol Symbol
    */
    function symbolIsAvailable(bytes memory symbol) public view returns (bool);

    /**
    * @notice Checks owner
    * @param symbol Symbol
    * @param owner Address for verification
    */
    function isSymbolOwner(bytes memory symbol, address owner) public view returns (bool);

    /**
    * @notice Register token to the symbol
    * @param sender Token issuer address
    * @param symbol Created token symbol
    * @param tokenAddress Address of the registered token
    */
    function registerTokenToTheSymbol(
        address sender, 
        bytes memory symbol, 
        address tokenAddress
    ) 
        public;

    /**
    * @notice Update symbols expiration interval
    * @param interval New expiration interval
    */
    function updateExpirationInterval(uint interval) public;

    /**
    * @notice Return token registred on the symbol
    */
    function getTokenBySymbol(bytes memory symbol) public view returns (address);

    /**
    * @notice Return symbol expire date
    */
    function getSymbolExpireDate(bytes memory symbol) public view returns (uint);

    /**
    * @notice Return issuer name
    */
    function getIssuerNameBySymbol(bytes memory symbol) public view returns (bytes memory);
}