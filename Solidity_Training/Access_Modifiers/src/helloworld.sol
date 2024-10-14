
// SPDX-License-Identifier: BUSL-1.1
pragma solidity^0.8.13;

contract Parent {
    // Tao hop dong Parent
    uint256 internal _value;
}
contract Child is Parent {
    // Hợp dồng Child được kế thừa từ hợp đồng Parent
    function getValue(uint256 newValue) public {
        _value = newValue;
        //Chuyen sang public
    }
    function getValue() public returns (uint256)
    {
        return _value;
    }
}
