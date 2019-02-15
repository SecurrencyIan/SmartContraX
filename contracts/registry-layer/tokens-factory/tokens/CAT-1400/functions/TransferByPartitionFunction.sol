pragma solidity >0.4.99 <0.6.0;


/**
* @title Transfer by partition
*/
contract TransferByPartitionFunction {
    /**
    * @notice Write info the log about tokens transfer
    * @param from  Sender address
    * @param to A recipient address
    * @param value Number of the transferred tokens
    * @dev Implemented for backward compatibility with ERC-20
    * @dev https://theethereum.wiki/w/index.php/ERC20_Token_Standard
    */
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /**
    * @notice Write info to the log about tokens transfer in the partition
    * @param fromPartition Partition identifier
    * @param operator Operator address
    * @param from Sender's address
    * @param to Address of the recipient
    * @param value Number of the transferred tokens
    * @param data Additional data
    * @param operatorData Additional data from the operator
    * @dev https://github.com/ethereum/EIPs/issues/1411
    */
    event TransferByPartition(
        bytes32 indexed fromPartition,
        address operator,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );

    /**
    * @notice Generate storage key for the balances 
    * @dev The positions are found by adding an offset of keccak256(k1 . k2 . p)
    * @dev Balances mapping position in the storage = 0x3EB
    * @dev mapping(bytes32=>mapping(address=>uint256))
    * @dev https://solidity.readthedocs.io/en/v0.5.0/miscellaneous.html#layout-of-state-variables-in-storage
    * @param holder Token holder address
    * @param partition Partition identifier
    * @return hash which represents storage key
    */
    function getBalanceKey(bytes32 partition, address holder) internal pure returns (bytes32 key) {
        bytes memory buffer = new bytes(0x5C);
        assembly {
            mstore(add(buffer, 0x20), partition)
            mstore(add(buffer, 0x40), holder)
            mstore(add(buffer, 0x5C), 0x3EB)
        }
        
        return keccak256(buffer);
    }

    /**
    * @notice Partition Token Transfer
    * @param partition Partition identifier
    * @param to A recipient address
    * @param value Number of the tokens to transfer
    * @dev https://github.com/ethereum/EIPs/issues/1411
    * @dev sig: 0xf3d490db
    */
    function transferByPartition(
        bytes32 partition,
        address to,
        uint256 value,
        bytes calldata //data
    )
        external
        returns (bytes32)
    {
        require(partition != bytes32(0x00), "Invalid partition.");
        require(to != address(0x00), "Invalid recipient address.");
        require(value != 0x00, "Invalid number of the tokens.");

        bytes32 senderKey = getBalanceKey(partition, msg.sender);
        bytes32 recipientKey = getBalanceKey(partition, to);

        uint senderBal;
        uint recipientBal;
        assembly {
            senderBal := sload(senderKey)
            recipientBal := sload(recipientKey)
        }
        require(senderBal >= value, "Insufficiency funds on the balance.");
        assert(recipientBal + value > recipientBal);

        assembly{
            sstore(senderKey, sub(senderBal, value))
            sstore(recipientKey, add(recipientBal, value))
        }

        writeInfoToTheLog(partition, to, value);
    }

    /**
    * @notice Write info to the log about transfer
    * @param partition Partition identifier
    * @param to A recipient address
    * @param value Number of the tokens
    */
    function writeInfoToTheLog(bytes32 partition, address to, uint256 value) internal {
        // ERC-20 transfer event
        emit Transfer(msg.sender, to, value);

        bytes memory data = new bytes(0x00);
        bytes memory operatorData = new bytes(0x00);

        // ERC-14000 transfer event
        emit TransferByPartition(
            partition,
            address(0x00),
            msg.sender,
            to,
            value,
            data,
            operatorData
        );
    }
}