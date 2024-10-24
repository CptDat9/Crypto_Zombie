## Chương 7: Tính toán Giá ETH

Khi hợp đồng thông minh chỉ mong đợi một câu trả lời, việc gửi phản hồi đến người gọi chỉ đơn giản là gọi hàm `callback` của `callerContractInstance` như sau:

```solidity
callerContractInstance.callback(_ethPrice, _id);
```
Nhưng bây giờ, sẽ có tối đa numOracles phản hồi cho mỗi yêu cầu. Và điều thú vị ở đây là hợp đồng thông minh không thể tự khởi tạo hành động. Nói cách khác, bạn không thể sử dụng một cấu trúc tương tự như đã sử dụng trong thành phần JavaScript của oracle:

```javascript
setInterval(async () => {
  doSomething()
}, SLEEP_INTERVAL)
```
Thay vào đó, hợp đồng thông minh cần được kích hoạt bằng cách nào đó.

Và trong trường hợp này, kích hoạt là việc gọi hàm setLatestEthPrice.
Vì vậy, thay vì trả lời câu hỏi "khi nào là thời điểm thích hợp để tính giá ETH", bạn nên trả lời một câu hỏi khác - bao nhiêu phản hồi là đủ để oracle tính toán giá ETH và gửi nó đến khách hàng.
Bạn có thể nghĩ rằng hợp đồng nên chờ cho đến khi tất cả numOracles gửi phản hồi. Nói cách khác, hợp đồng sẽ đợi mỗi oracle gửi phản hồi. Nhưng hãy xem xét sâu hơn.
Tại bất kỳ thời điểm nào, một oracle có thể tạm dừng để bảo trì hoặc mất kết nối mạng. Nếu điều này xảy ra, hợp đồng của bạn sẽ không thể hoàn thành bất kỳ yêu cầu nào cho đến khi các vấn đề trên được khắc phục.
### Phương pháp linh hoạt hơn
Một phương pháp linh hoạt hơn là xác định một ngưỡng. Khi số lượng phản hồi bằng với ngưỡng này, hợp đồng thông minh sẽ tính toán giá ETH và gửi nó đến người gọi.
Tất nhiên, phương pháp này không phải là hoàn hảo, nhưng nó sẽ giảm thiểu tốt hơn các vấn đề có thể xảy ra.
## Code P7
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
    // Start here
    uint numResponses = requestIdToResponse[_id].length;
    if (numResponses  == THRESHOLD){
      delete pendingRequests[_id];
      CallerContractInterface callerContractInstance;
      callerContractInstance = CallerContractInterface(_callerAddress);
      callerContractInstance.callback(_ethPrice, _id);
      emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
    }

  }
}
```
