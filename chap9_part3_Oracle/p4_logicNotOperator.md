### Chương 4: Toán tử PHỦ ĐỊNH (Logical NOT Operator)

Trong bài học này, bạn sẽ tiếp tục phát triển hàm `addOracle`.

Như đã thấy trong bài học đầu tiên, hợp đồng thông minh `Roles` triển khai ba hàm: `add`, `remove`, và `has`.

### Toán tử PHỦ ĐỊNH (Logical NOT Operator)
Để đảm bảo rằng một địa chỉ không phải là oracle (người tiên tri) đã tồn tại, bạn sẽ phải sử dụng toán tử phủ định `!`. Nói đơn giản, `!` phủ định giá trị của tham số nó nhận. Vì vậy, nếu `oracles.has(_owner)` trả về giá trị `true`, thì `!oracles.has(_owner)` sẽ trả về giá trị `false`.

Với điều đó đã được giải thích, chúng ta sẽ tiếp tục phát triển hàm `addOracle`.
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
  event AddOracleEvent(address oracleAddress);
  constructor (address _owner) public {
    owners.add(_owner);
  }
  function addOracle (address _oracle) public {
    require(owners.has(msg.sender), "Not an owner!");
    // Start here
    require(!oracles.has(_oracle), "Already an oracle!");
    oracles.add(_oracle);
    emit AddOracleEvent(_oracle);
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
