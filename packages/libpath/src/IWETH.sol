pragma solidity >=0.6.6;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
    function balanceOf(address guy) external returns (uint);
    function approve(address guy, uint wad) external returns (bool);
}
