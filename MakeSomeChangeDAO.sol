//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MakeSomeChangeDAO is Ownable {
    ERC20 public makeSomeChangeToken;

    uint private _totalSupply;
    mapping (address => uint256) internal _balances;

    function deposit(uint _amount) public {
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
    }
}