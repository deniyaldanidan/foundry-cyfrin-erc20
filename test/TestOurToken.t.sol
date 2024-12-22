// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract TestOurToken is Test {
    OurToken private ourToken;
    DeployOurToken private deployer;

    address private bob = makeAddr("bob");
    address private alice = makeAddr("alice");

    uint256 private constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWorks() public {
        uint256 initialAllowances = 10000;

        // * Bob approves alice to spend tokens on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowances);

        // * Now alice will spend the allowance amount, she gonna send it to her address
        uint256 transferredAllowance = 5000;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferredAllowance);

        // assert
        assertEq(ourToken.balanceOf(alice), transferredAllowance);
        assertEq(
            ourToken.balanceOf(bob),
            STARTING_BALANCE - transferredAllowance
        );
    }

    function testTransfer() public {
        // arrange
        uint256 transferAmount = 1 ether;

        // act
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        // assert
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testIsAllowanceApproved() public {
        uint256 allowanceAmount = 10 ether;

        // * bob is allowing alice to spend 10 ether worth of OT-TOKENS in his behalf
        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);
        console.log(ourToken.allowance(bob, alice));
        assertEq(ourToken.allowance(bob, alice), allowanceAmount);
    }
}
