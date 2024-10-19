/*
Chương 7: Modifier onlyOracle
Bạn đã tìm ra câu trả lời chưa?

Trước khi hoàn thành hàm callback, bạn phải đảm bảo rằng chỉ hợp đồng oracle mới được phép gọi nó.

Trong chương này, bạn sẽ tạo một modifier để ngăn chặn các hợp đồng khác gọi hàm callback của bạn.

Lưu ý: Chúng tôi sẽ không đi sâu vào cách các modifier hoạt động. Nếu bạn chưa rõ về chi tiết, hãy quay lại và xem các bài học trước.

Hãy nhớ rằng bạn đã lưu trữ địa chỉ của oracle vào một biến gọi là oracleAddress. Do đó, modifier chỉ cần kiểm tra rằng địa chỉ gọi hàm này là oracleAddress.

Nhưng làm thế nào để biết được địa chỉ nào gọi một hàm, bạn hỏi?

Trong Solidity, msg.sender là một biến đặc biệt chỉ định người gửi của thông điệp. Nói cách khác, bạn có thể sử dụng msg.sender để biết địa chỉ nào đã gọi hàm của bạn.
*/
pragma solidity 0.5.0;
import "./EthPriceOracleInterface.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
contract CallerContract is Ownable {
    uint256 private ethPrice;
    EthPriceOracleInterface private oracleInstance;
    address private oracleAddress;
    mapping(uint256=>bool) myRequests;
    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 id);
    event PriceUpdatedEvent(uint256 ethPrice, uint256 id);
    function setOracleInstanceAddress (address _oracleInstanceAddress) public onlyOwner {
      oracleAddress = _oracleInstanceAddress;
      oracleInstance = EthPriceOracleInterface(oracleAddress);
      emit newOracleAddressEvent(oracleAddress);
    }
    function updateEthPrice() public {
      uint256 id = oracleInstance.getLatestEthPrice();
      myRequests[id] = true;
      emit ReceivedNewRequestIdEvent(id);
    }
    function callback(uint256 _ethPrice, uint256 _id) public onlyOracle {
      require(myRequests[_id], "This request is not in my pending list.");
      ethPrice = _ethPrice;
      delete myRequests[_id];
      emit PriceUpdatedEvent(_ethPrice, _id);
    }
    modifier onlyOracle() {
      // Start here
      require(msg.sender == oracleAddress, "You are not authorized to call this function.");
      _;
    }

}
