/*
Chương 9: Hàm getLatestEthPrice - Phần tiếp theo

Tuyệt vời, bạn đã tính toán được request id.

Tiếp theo, bạn cần triển khai một hệ thống đơn giản để theo dõi các yêu cầu đang chờ xử lý. Giống như cách bạn đã làm với hợp đồng caller, lần này bạn sẽ sử dụng một mapping. Hãy đặt tên cho nó là pendingRequests.

Hàm getLatestEthPrice cũng nên kích hoạt một sự kiện (event) và cuối cùng, nó nên trả về request id.

Hãy xem cách bạn có thể triển khai điều này trong mã code.
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

    // Start here
    pendingRequests[id] = true;
    emit GetLatestEthPriceEvent(msg.sender, id);
    return id;
  }
}
