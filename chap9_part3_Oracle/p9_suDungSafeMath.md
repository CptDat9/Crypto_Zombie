## Chương 9: Sử dụng SafeMath

Bây giờ, hãy dành thời gian để thảo luận về bảo mật trong hợp đồng của bạn.

Thực hiện phép cộng như `computedEthPrice += requestIdToResponse[_id][f].ethPrice;` hoạt động tốt với một số lượng lớn oracle, nhưng vấn đề là giá trị `computedEthPrice` có thể bị tràn số nếu số lượng oracle quá lớn.

Trước tiên, hãy xem **tràn số** là gì.

Giả sử bạn định nghĩa một biến `uint8` như sau:

```solidity
uint8 exampleOverflow = 255;
```
Vì biến `exampleOverflow`chỉ có thể chứa 8 bit, giá trị lớn nhất mà bạn có thể lưu trữ là `255 (2^8 - 1 hay 11111111)`.

Bây giờ, nếu bạn thực hiện dòng mã sau:

```solidity
exampleOverflow++;
```
Thì biến `exampleOverflow` sẽ có giá trị bằng 0, ngay cả khi bạn vừa tăng nó lên. Hãy thử nếu bạn muốn 😉.

Tương tự, nếu bạn trừ 1 từ một biến `uint8` có giá trị bằng 0, kết quả sẽ là 255. Đây được gọi là tràn ngược.

Bây giờ, mặc dù hợp đồng đang sử dụng `uint`, việc tràn số là điều rất khó xảy ra, nhưng việc bảo vệ hợp đồng chống lại hành vi không mong muốn là một thói quen tốt.

Thư viện `SafeMath`
Đối với những tình huống như thế này, `OpenZeppelin` đã tạo ra thư viện `SafeMath`. Hãy xem đoạn mã sau:

```solidity
pragma solidity ^0.5.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
```
Giống như những gì bạn đã làm trong các chương trước với `Roles`, đầu tiên bạn sẽ thêm dòng mã sau:

```solidity
using SafeMath for uint256;
```
Sau đó, bạn có thể sử dụng các hàm của SafeMath: `add`, `sub`, `mul`, và `div`:

```solidity
using SafeMath for uint256;
uint256 test = 4;
test = test.div(2);  // test giờ có giá trị 2
test = test.add(5);  // test giờ có giá trị 7
```
Sử dụng `SafeMath` giúp đảm bảo rằng các phép toán trong hợp đồng thông minh của bạn không gặp phải lỗi tràn số, giúp tăng tính bảo mật.
## Code P9:
```solidity
pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/access/Roles.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./CallerContractInterface.sol";
contract EthPriceOracle {
  using Roles for Roles.Role;
  Roles.Role private owners;
  Roles.Role private oracles;
  // 1. Tell your contract to use `SafeMath` for `uint256`
  using SafeMath for uint256;
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
      uint computedEthPrice = 0;
        for (uint f=0; f < requestIdToResponse[_id].length; f++) {
        computedEthPrice = computedEthPrice.add(requestIdToResponse[_id][f].ethPrice); // Replace this with a `SafeMath` method
      }
      computedEthPrice = computedEthPrice.div(numResponses); // Replace this with a `SafeMath` method
      delete pendingRequests[_id];
      CallerContractInterface callerContractInstance;
      callerContractInstance = CallerContractInterface(_callerAddress);
      callerContractInstance.callback(_ethPrice, _id);
      emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
    }
  }
}

```
