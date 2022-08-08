// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract LockedMakeSomeChange is ReentrancyGuard, Pausable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address[] public rewardTokens;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function lock(IERC20 token, uint256 amount) external nonReentrant whenNotPaused {
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        token.transferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function unlock(IERC20 token, address recipient, uint256 amount) public nonReentrant {
        require(amount > 0, "Cannot withdraw 0");
        require(recipient != address(0), "ERC20: to address is not valid");
        require(_balances[msg.sender] > 3, "Need 3 tokens to withdraw");
        require(recipient != msg.sender, "Token must be donated or burned");

        _totalSupply = _totalSupply.sub(amount);
        _balances[recipient] = _balances[recipient].sub(amount);
        token.transfer(recipient, amount);
        emit Withdrawn(recipient, amount);
    }

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
}
