### Chương 1: Sử Dụng Vai Trò (Roles)

Trong các bài học trước, bạn đã sử dụng hợp đồng `Ownable` của OpenZeppelin để triển khai cơ chế kiểm soát truy cập đơn giản dựa trên quyền sở hữu. Nói một cách đơn giản, chỉ có owner (chủ sở hữu) mới được phép gọi hàm `setLatestEthPrice`.

Giờ đây, để làm cho oracle trở nên phi tập trung hơn, chúng ta cần triển khai một hệ thống cung cấp các cấp độ truy cập khác nhau: **owner** và **oracle**. **Owner** nên có quyền thêm và xóa các **oracle**. Ngược lại, **oracle** phải được phép cập nhật giá ETH bằng cách gọi hàm `setLatestEthPrice`.

#### Sử Dụng Roles

May mắn thay, OpenZeppelin cung cấp một thư viện gọi là **Roles** để thực hiện công việc này. Để sử dụng, đầu tiên bạn phải import nó như sau:

```solidity
import "openzeppelin-solidity/contracts/access/Roles.sol";
pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Cấp quyền cho tài khoản này.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Xóa quyền của tài khoản này.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Kiểm tra xem tài khoản có quyền này không.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}
```
Chú ý rằng Roles là một thư viện. Điều này có nghĩa là chúng ta có thể đính kèm nó vào kiểu dữ liệu Roles.Role như sau:

```solidity
using Roles for Roles.Role;
```
Khi thực hiện điều này, tham số đầu tiên được mong đợi bởi các hàm add, remove, và has (đó là Roles storage role) sẽ tự động được truyền, nghĩa là chúng ta có thể sử dụng các hàm này để quản lý vai trò như sau:

```solidity
oracles.add(_oracle);   // Thêm `_oracle` vào danh sách các oracle
oracles.remove(_oracle); // Xóa `_oracle` khỏi danh sách các oracle
oracles.has(msg.sender); // Trả về `true` nếu `msg.sender` là một `oracle`
```
# Code P1:
```solidity
pragma solidity 0.5.0;
// 1. On the next line, import from the `openzeppelin-solidity/contracts/access/Roles.sol` file
import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./CallerContractInterface.sol";
contract EthPriceOracle  { //2. Remove `is Ownable`
  // 2. Continue here
  using Roles for Roles.Role;
  Roles.Role private owners;
  Roles.Role private oracles;
  uint private randNonce = 0;
  uint private modulus = 1000;
  mapping(uint256=>bool) pendingRequests;
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
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
