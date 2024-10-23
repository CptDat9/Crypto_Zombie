### Chương 5: Xóa một Oracle

Tuyệt vời! Bạn đã triển khai thành công hàm để thêm một oracle. Bây giờ, bạn cần viết một hàm để xóa một oracle. Logic của hàm này sẽ tương tự như hàm `addOracle` mà bạn đã thực hiện.

### Tuy nhiên, có thêm một vấn đề cần lưu ý.

Điều gì sẽ xảy ra nếu bạn vô tình xóa oracle cuối cùng? Khi đó, hợp đồng thông minh sẽ trở nên vô dụng cho đến khi bạn tìm ra sự cố và khôi phục được oracle. Đây là một lỗi tiềm tàng nghiêm trọng. Để ngăn ngừa điều này, bạn cần một cơ chế an toàn để theo dõi số lượng oracle hiện có.

### Giải pháp là gì?

Để thực hiện cơ chế an toàn này, bạn sẽ tạo một biến mới gọi là `numOracles`. Mỗi khi một oracle mới được thêm vào, hàm `addOracle` sẽ tăng giá trị của biến `numOracles` lên 1. Khi một oracle bị xóa, bạn sẽ cần đảm bảo rằng biến `numOracles` luôn lớn hơn 1. Nếu không, bạn sẽ không thể xóa oracle cuối cùng và duy trì được ít nhất một oracle trong hệ thống.

### Cách triển khai

- **Bước 1**: Định nghĩa một biến toàn cục `numOracles` để lưu trữ số lượng oracle hiện tại.
- **Bước 2**: Trong hàm `addOracle`, mỗi lần thêm một oracle thành công, bạn sẽ tăng `numOracles` lên.
- **Bước 3**: Trong hàm `removeOracle`, trước khi xóa một oracle, bạn sẽ sử dụng câu lệnh `require(numOracles > 1)` để đảm bảo rằng luôn có ít nhất một oracle trong hệ thống. Nếu điều kiện này đúng, bạn sẽ gọi hàm `oracles.remove` để xóa oracle và giảm giá trị của `numOracles`.

### Ví dụ:
```solidity
// Định nghĩa biến theo dõi số lượng oracle
uint256 public numOracles;

// Hàm thêm oracle
function addOracle(address _oracle) public {
    require(!oracles.has(_oracle), "Địa chỉ đã là oracle");
    oracles.add(_oracle);
    numOracles++;  // Tăng số lượng oracle
}

// Hàm xóa oracle
function removeOracle(address _oracle) public {
    require(numOracles > 1, "Không thể xóa oracle cuối cùng");
    oracles.remove(_oracle);
    numOracles--;  // Giảm số lượng oracle
}
```
## Code P5:
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
  // 1. Initialize `numOracles`
  uint private numOracles =0;
  mapping(uint256=>bool) pendingRequests;
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  event AddOracleEvent(address oracleAddress);
  //2. Declare `RemoveOracleEvent`
  event RemoveOracleEvent (address oracleAddress);
  constructor (address _owner) public {
    owners.add(_owner);
  }
  function addOracle (address _oracle) public {
    require(owners.has(msg.sender), "Not an owner!");
    require(!oracles.has(_oracle), "Already an oracle!");
    oracles.add(_oracle);
    numOracles++;
    emit AddOracleEvent(_oracle);
  }
  function removeOracle (address _oracle) public {
    require(owners.has(msg.sender), "Not an owner!");
    require(oracles.has(_oracle), "Not an oracle!");
    // 3. Continue here
       require(numOracles > 1, "Do not remove the last oracle!");
    oracles.remove(_oracle);
    numOracles--;
    emit RemoveOracleEvent(_oracle);
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

