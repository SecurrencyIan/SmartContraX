pragma solidity ^0.4.24;

import "./SecuritiesNFT.sol";

/**
* @title SLS-721 Token
*/
contract SLS721Token is SecuritiesNFT {
    constructor(
        string _name,
        string _symbol,
        address _issuer,
        address _transferModule,
        address _permissionModule
    ) 
        public
        ERC721Token(_name, _symbol)
        SecuritiesToken(_issuer)
        SecuritiesNFT(_transferModule)
        Protected(_permissionModule)
    { }

    /**
    * @dev Function to mint tokens
    * @param to The address that will receive the minted tokens.
    * @param tokenId The token id to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(
        address to,
        uint256 tokenId
    )
        public
        verifyPermissionForCurrentToken(msg.sig, msg.sender)
        returns (bool)
    {
        _mint(to, tokenId);
        return true;
    }

    function mintWithTokenURI(
        address to,
        uint256 tokenId,
        string tokenURI
    )
        public
        returns (bool)
    {
        mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return true;
    }
}