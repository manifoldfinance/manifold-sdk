pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Noeth.sol";

contract NoethTest is DSTest {
    Noeth eth;

    function setUp() public {
        eth = new Noeth();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
