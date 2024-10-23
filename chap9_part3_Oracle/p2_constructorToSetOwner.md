### Chương 2: Sử Dụng Constructor Để Thiết Lập Chủ Sở Hữu (Owner)

Giờ đây, hợp đồng của bạn không kế thừa từ `Ownable`, vì vậy bạn phải tìm một cách để chỉ định chủ sở hữu (owner) của nó. Bạn sẽ làm điều này bằng cách thêm một **constructor**. Đây là một hàm đặc biệt chỉ được thực thi một lần duy nhất khi hợp đồng được triển khai.

Dưới đây là một ví dụ về việc sử dụng **constructor**:

```solidity
contract MyAwesomeContract {
  constructor (address _owner) public {
    // Thực hiện điều gì đó
  }
}
```
Để làm cho điều này hoạt động, constructor của bạn cần phải có một tham số – địa chỉ của chủ sở hữu. Do đó, bạn cần chỉnh sửa file migration và sửa dòng triển khai hợp đồng thông minh như sau:

```solidity
deployer.deploy(EthPriceOracle, '0xb090d88a3e55906de49d76b66bf4fe70b9d6d708')
```
Tiếp theo, mã bên trong constructor phải thêm chủ sở hữu (được truyền vào từ tham số của hàm) vào danh sách các chủ sở hữu:

```solidity
owners.add(_owner);
```
# Code P2: 
```solidity
pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./CallerContractInterface.sol";
contract EthPriceOracle {
  using Roles for Roles.Role;
  Roles.Role private owners;
  Roles.Role private oracles;
  uint private randNonce = 0;
  uint private modulus = 1000;
  mapping(uint256=>bool) pendingRequests;
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  // Start here
  constructor (address _owner) public{
    owners.add(_owner);
  }
  function getLatestEthPrice() public returns (uint256) {
    randNonce++;
    uint id = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % modulus;
    pendingRequests[id] = true;
    emit GetLatestEthPriceEvent(msg.sender, id);
    return id;
  }
  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public onlyOwner {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    CallerContractInterface callerContractInstance;
    callerContractInstance = CallerContractInterface(_callerAddress);
    callerContractInstance.callback(_ethPrice, _id);
    emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
  }
}
```

