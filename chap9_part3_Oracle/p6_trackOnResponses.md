### Chương 6: Theo dõi các Phản hồi

Trong chương này, bạn sẽ bắt đầu cập nhật hàm `setLatestEthPrice` để làm cho hợp đồng hoạt động theo hướng phi tập trung hơn.

Khi nhiều oracle được thêm vào, hợp đồng của bạn sẽ mong đợi nhiều hơn một phản hồi cho mỗi yêu cầu. Do đó, cách bạn theo dõi các phản hồi (bằng cách thêm chúng vào mapping `pendingRequests`) cần phải thay đổi.

### Vậy bạn nên xử lý việc này như thế nào? 🤔

Để theo dõi tất cả mọi thứ, với mỗi phản hồi, bạn sẽ muốn lưu trữ các thông tin sau:

- `oracleAddress` (Địa chỉ của oracle)
- `callerAddress` (Địa chỉ của người yêu cầu)
- `ethPrice` (Giá ETH)

Sau đó, bạn sẽ muốn liên kết các biến này với mã nhận dạng của yêu cầu.

### Và còn một điều nữa: làm thế nào để không phải bỏ hết mọi công việc đã làm và bắt đầu lại từ đầu? 🤓

Để làm được điều này, bạn sẽ sử dụng một `mapping` để liên kết mỗi ID yêu cầu với một mảng các cấu trúc (**struct**) chứa các biến `oracleAddress`, `callerAddress`, và `ethPrice`.

### Lưu ý:

Trong Solidity, bạn có thể định nghĩa một cấu trúc (**struct**) như sau:

```solidity
struct MyStruct {
  address anAddress;
  uint256 aNumber;
}
```
Sau đó, bạn có thể khởi tạo `MyStruct` như sau:
```solidity
MyStruct memory myStructInstance; // khai báo struct
myStructInstance = MyStruct(msg.sender, 200); // khởi tạo struct
```
Bạn có nhận ra từ khóa `memory` không? Bắt đầu từ phiên bản Solidity 5.0, bạn bắt buộc phải chỉ định vị trí lưu trữ cho mọi kiểu tham chiếu!

Tất nhiên, bạn có thể thay đổi giá trị của một thành phần trong struct bằng cách sử dụng câu lệnh gán, giống như cách bạn gán giá trị cho các biến thông thường. 
Lưu ý rằng trong Solidity, ta tham chiếu đến các struct và các thành phần của chúng bằng cú pháp dấu chấm:
```solidity
  myStructInstance.anAddress = otherAddress
```
## Code P6
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
  uint private numOracles = 0;
  mapping(uint256=>bool) pendingRequests;
  //1. Define `Response`
  struct Response{
    address oracleAddress;
    address callerAddress;
    uint256 ethPrice;
  }

  mapping (uint256=>Response[]) public requestIdToResponse;
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  event AddOracleEvent(address oracleAddress);
  event RemoveOracleEvent(address oracleAddress);
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
    require (numOracles > 1, "Do not remove the last oracle!");
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
  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public {
    require(oracles.has(msg.sender), "Not an oracle!");
    require(pendingRequests[_id], "This request is not in my pending list.");
    // 2. Continue here
    Response memory resp;
    resp = Response(msg.sender, _callerAddress, _ethPrice);
    requestIdToResponse[_id].push(resp);
    delete pendingRequests[_id];
    CallerContractInterface callerContractInstance;
    callerContractInstance = CallerContractInterface(_callerAddress);
    callerContractInstance.callback(_ethPrice, _id);
    emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
  }
}

```
