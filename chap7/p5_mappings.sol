/*
Chương 5: Sử dụng Mapping để Theo dõi Các Yêu cầu

Tuyệt vời, bạn đã hoàn thành chức năng setOracleInstanceAddress!

Bây giờ, giao diện người dùng của bạn có thể gọi nó để thiết lập địa chỉ của oracle.

Tiếp theo, hãy xem cách giá ETH được cập nhật.

Để khởi tạo một cập nhật giá ETH, hợp đồng thông minh cần gọi hàm getLatestEthPrice của oracle. Do tính chất bất đồng bộ của nó, hàm getLatestEthPrice không thể trả về thông tin này. Thay vào đó, nó trả về một id duy nhất cho mỗi yêu cầu. Sau đó, oracle sẽ tiếp tục lấy giá ETH từ API Binance và thực hiện một hàm callback được công khai bởi hợp đồng gọi. Cuối cùng, hàm callback sẽ cập nhật giá ETH trong hợp đồng gọi.

Đây là một điểm rất quan trọng, vì vậy hãy dành vài phút để suy nghĩ về điều này trước khi tiến lên.

Bây giờ, liệu việc triển khai điều này có nghe có vẻ khó không? Thực ra, cách mà điều này hoạt động rất đơn giản và sẽ khiến bạn ngạc nhiên. Hãy kiên nhẫn với tôi trong hai chương tiếp theo 🤓.

Mappings

Mỗi người dùng của dapp của bạn có thể khởi tạo một thao tác yêu cầu hợp đồng gọi phải thực hiện để cập nhật giá ETH. Vì hợp đồng gọi không thể kiểm soát khi nào nó sẽ nhận được phản hồi, bạn phải tìm cách theo dõi những yêu cầu đang chờ xử lý này. Bằng cách này, bạn sẽ đảm bảo rằng mỗi cuộc gọi đến hàm callback liên kết với một yêu cầu hợp lệ.

Để theo dõi các yêu cầu, bạn sẽ sử dụng một mapping có tên là myRequests. Trong Solidity, một mapping về cơ bản là một bảng băm mà trong đó tất cả các khóa có thể có. Nhưng có một điều kiện. Ban đầu, mỗi giá trị được khởi tạo với giá trị mặc định của kiểu đó.

Bạn có thể định nghĩa một mapping bằng cách sử dụng cú pháp như sau:

solidity
mapping(address => uint) public balances;
Bạn có thể đoán đoạn mã này làm gì không? Thực ra, nó thiết lập số dư của tất cả các địa chỉ có thể thành 0. Tại sao lại là 0? Bởi vì đó là giá trị mặc định cho uint.

Việc thiết lập số dư cho msg.sender thành someNewValue thật đơn giản:

solidity
balances[msg.sender] = someNewValue;
*/
pragma solidity 0.5.0;
import "./EthPriceOracleInterface.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
contract CallerContract is Ownable {
    EthPriceOracleInterface private oracleInstance;
    address private oracleAddress;
    mapping(uint256=>bool) myRequests;
    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 id);
    function setOracleInstanceAddress (address _oracleInstanceAddress) public onlyOwner {
      oracleAddress = _oracleInstanceAddress;
      oracleInstance = EthPriceOracleInterface(oracleAddress);
      emit newOracleAddressEvent(oracleAddress);
    }
    // Define the `updateEthPrice` function
    function updateEthPrice() public {
      uint256 id = oracleInstance.getLatestEthPrice();
      myRequests[id] = true;
      emit ReceivedNewRequestIdEvent(id);
    }
}
