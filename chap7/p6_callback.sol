/*
Chương 6: Hàm Callback

Logic của hợp đồng gọi gần như đã hoàn thành, nhưng còn một điều nữa bạn cần phải chú ý.

Như đã đề cập trong chương trước, việc gọi API công khai của Binance là một hoạt động bất đồng bộ. Do đó, hợp đồng thông minh gọi phải cung cấp một hàm callback mà oracle sẽ gọi sau đó, tức là khi giá ETH đã được lấy.

Dưới đây là cách hàm callback hoạt động:

Trước tiên, bạn cần đảm bảo rằng hàm chỉ có thể được gọi với một id hợp lệ. Để làm điều đó, bạn sẽ sử dụng một câu lệnh require.

Nói một cách đơn giản, câu lệnh require sẽ ném ra một lỗi và dừng việc thực thi hàm nếu điều kiện là sai.

Hãy cùng xem một ví dụ từ tài liệu chính thức của Solidity:

solidity
require(msg.sender == chairperson, "Only chairperson can give right to vote.");
Tham số đầu tiên sẽ được đánh giá là đúng hoặc sai. Nếu nó là sai, việc thực thi hàm sẽ dừng lại và hợp đồng thông minh sẽ ném ra lỗi - "Only chairperson can give right to vote."

Khi bạn biết rằng id là hợp lệ, bạn có thể tiếp tục và xóa nó khỏi mapping myRequests.

Lưu ý: Để xóa một phần tử khỏi một mapping, bạn có thể sử dụng cú pháp như sau: delete myMapping[key];

Cuối cùng, hàm của bạn nên phát ra một sự kiện để thông báo cho giao diện người dùng biết rằng giá đã được cập nhật thành công.
*/
pragma solidity 0.5.0;
  import "./EthPriceOracleInterface.sol";
  import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
  contract CallerContract is Ownable {
      // 1. Declare ethPrice
      uint256 private ethPrice;
      EthPriceOracleInterface private oracleInstance;
      address private oracleAddress;
      mapping(uint256=>bool) myRequests;
      event newOracleAddressEvent(address oracleAddress);
      event ReceivedNewRequestIdEvent(uint256 id);
      // 2. Declare PriceUpdatedEvent
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
      function callback(uint256 _ethPrice, uint256 _id) public {
        // 3. Continue here
        require(myRequests[_id], "This request is not in my pending list.");
        ethPrice = _ethPrice;
        delete myRequests[_id];
        emit PriceUpdatedEvent(_ethPrice, _id);
      }
  }
