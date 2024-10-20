/*

Chương 10: Hàm setLatestEthPrice

Tuyệt vời! Trong chương này, bạn sẽ kết hợp những gì đã học để viết hàm setLatestEthPrice. Đây sẽ là phần phức tạp hơn một chút, nhưng không có gì phải lo lắng. Mình sẽ tránh các bước nhảy suy nghĩ lớn và đảm bảo mỗi bước đều được giải thích rõ ràng.

JavaScript component của oracle (phần chúng ta sẽ viết trong bài học tiếp theo) sẽ lấy giá ETH từ API công khai của Binance và sau đó gọi hàm setLatestEthPrice, truyền vào các tham số sau:

Giá ETH,
Địa chỉ của hợp đồng đã khởi tạo yêu cầu,
ID của yêu cầu.
Đầu tiên, hàm của bạn phải đảm bảo rằng chỉ chủ sở hữu mới có thể gọi hàm này. Sau đó, tương tự như mã bạn đã viết ở Chương 6, hàm của bạn nên kiểm tra xem request id có hợp lệ không. Nếu có, nó sẽ xóa yêu cầu đó khỏi pendingRequests.
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
  // Start here
  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public onlyOwner {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    
  }
}
