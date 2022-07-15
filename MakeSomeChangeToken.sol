//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./LockedMakeSomeChange.sol";

contract MakeSomeChangeToken is ERC20 {

    using SafeMath for uint256;

    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint256 internal _totalSupply;
    address internal _makeSomeChangeDAO;
    LockedMakeSomeChange internal _lockedTokens;

    mapping (address => uint256) internal _balances;

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply,
        address makeSomeChangeDAO,
        LockedMakeSomeChange lockedTokens
    ) ERC20(name, symbol)
    {
        _symbol = symbol;
        _name = name;
        _decimals = decimals;
        _totalSupply = totalSupply;
        _balances[msg.sender] = totalSupply;
        _makeSomeChangeDAO = makeSomeChangeDAO;
        _lockedTokens = lockedTokens;

        _mint(makeSomeChangeDAO, 100);
    }

    function transfer(
        address recipient,
        uint256 amount,
        address charity
    ) public
    returns (bool)
    {
        require(recipient != address(0), "ERC20: to address is not valid");
        require(amount <= _balances[msg.sender], "ERC20: insufficient balance");

        _balances[msg.sender] = SafeMath.sub(_balances[msg.sender], amount);
        _balances[recipient] = SafeMath.add(_balances[recipient], amount);

        uint256 quarter = amount.div(4);
        // Charity
        emit Transfer(msg.sender, charity, quarter);
        // MakeSomeChangeDAO
        emit Transfer(msg.sender, _makeSomeChangeDAO, quarter);
        // Back to user
        emit Transfer(msg.sender, msg.sender, quarter);
        // Locked
        _lockedTokens.lock(this, quarter);

        return true;
    }
}
