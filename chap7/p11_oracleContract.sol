/*
Chương 11: Hợp đồng Oracle

Hàm setLatestEthPrice gần như đã hoàn thành. Tiếp theo, bạn cần thực hiện các bước sau:

Khởi tạo CallerContractInstance. Nếu bạn quên cách làm hoặc cần cảm hứng, hãy xem nhanh ví dụ sau:
solidity
MyContractInterface myContractInstance;
myContractInstance = MyContractInterface(contractAddress);
Với hợp đồng gọi (caller contract) được khởi tạo, bạn có thể thực thi phương thức callback của nó và truyền giá ETH mới cùng với ID của yêu cầu.
Cuối cùng, bạn sẽ cần kích hoạt một sự kiện (event) để thông báo cho giao diện người dùng rằng giá đã được cập nhật thành công.
*/
pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./CallerContractInterface.sol";
contract EthPriceOracle is Ownable {
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
  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress,   uint256 _id) public onlyOwner {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    // Start here
    CallerContractInterface callerContractInstance;
    callerContractInstance = CallerContractInterface(_callerAddress);
    callerContractInstance.callback(_ethPrice, _id);
    emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);
  }

}
