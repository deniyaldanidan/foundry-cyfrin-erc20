// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint initialSupply) ERC20("Our Token", "OT") {
        _mint(msg.sender, initialSupply);
    }
}
