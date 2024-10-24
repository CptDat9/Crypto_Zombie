### Chương 8: Tính toán Giá ETH - Tiếp tục

Bây giờ, hãy quay lại cách bạn sẽ tính toán giá ETH. Cách chúng ta sẽ làm là tính trung bình của tập hợp các phản hồi.

Mặc dù việc tính trung bình không phức tạp, bạn cần lưu ý rằng phương pháp này có thể khiến hợp đồng dễ bị tấn công nếu một số oracle cố tình thao túng giá. Đây là một vấn đề không dễ giải quyết, và giải pháp nằm ngoài phạm vi của bài học này. Một cách để giải quyết vấn đề này là loại bỏ các giá trị ngoại lai bằng cách sử dụng **quartiles** và **interquartile ranges**. Bạn có thể tham khảo thêm chi tiết về **quartiles** trên trang web "Math is Fun". Vì chúng ta đang xây dựng một oracle cho mục đích trình diễn, chúng ta sẽ chấp nhận sự đánh đổi này khi sử dụng một thuật toán đơn giản để triển khai, mặc dù biết rằng nó không hoàn toàn an toàn.

### Cách tính trung bình của tập hợp phản hồi

Để tính trung bình của tập hợp phản hồi, bạn sẽ phải sử dụng vòng lặp `for`.

Ví dụ, cú pháp để tính tổng của tất cả các phần tử trong một mảng như sau:

```solidity
uint sum = 0;
for (uint f = 0; f < myArray.length; f++) {
    sum += myArray[f];
}
```
Trong ví dụ này, `f` là biến chứa phần tử hiện tại từ mảng `myArray`. Code trong thân của vòng lặp `for` sử dụng `f` để tính tổng `sum`.
## Code P8:
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
  uint private THRESHOLD = 0;
  mapping(uint256=>bool) pendingRequests;
  struct Response {
    address oracleAddress;
    address callerAddress;
    uint256 ethPrice;
  }
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  event AddOracleEvent(address oracleAddress);
  event RemoveOracleEvent(address oracleAddress);
  event SetThresholdEvent (uint threshold);
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
  function setThreshold (uint _threshold) public {
    require(owners.has(msg.sender), "Not an owner!");
    THRESHOLD = _threshold;
    emit SetThresholdEvent(THRESHOLD);
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
    Response memory resp;
    resp = Response(msg.sender, _callerAddress, _ethPrice);
    requestIdToResponse[_id].push(resp);
    uint numResponses = requestIdToResponse[_id].length;
    if (numResponses == THRESHOLD) {
      // Start here
      uint computedEthPrice = 0;
      for (uint f = 0; f < requestIdToResponse[_id].length; f++){
        computedEthPrice += requestIdToResponse[_id][f].ethPrice;
      }
      computedEthPrice = computedEthPrice / numResponses;
      delete pendingRequests[_id];
      CallerContractInterface callerContractInstance;
      callerContractInstance = CallerContractInterface(_callerAddress);
      callerContractInstance.callback(_ethPrice, _id);
      emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
    }
  }
}
```

