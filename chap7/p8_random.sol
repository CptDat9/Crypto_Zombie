/*
Chương 8: Hàm getLatestEthPrice

Chúc mừng! Bạn đã hoàn thành việc triển khai hợp đồng thông minh cho người gọi 💪🏻💪🏻💪🏻.

Bây giờ, đã đến lúc tiến sang hợp đồng oracle. Hãy bắt đầu bằng việc xem qua những gì hợp đồng này cần làm.

Tóm tắt lại, hợp đồng oracle hoạt động như một cầu nối, cho phép các hợp đồng gọi truy cập nguồn cấp giá ETH. Để làm điều này, nó chỉ cần triển khai hai hàm: getLatestEthPrice và setLatestEthPrice.

Hàm getLatestEthPrice
Để cho phép các hợp đồng gọi theo dõi các yêu cầu của họ, hàm getLatestEthPrice nên đầu tiên tính toán ID yêu cầu và, vì lý do bảo mật, số này nên khó đoán.

Vì sao lại cần bảo mật?

Trong bài học thứ ba, bạn sẽ làm cho oracle trở nên phi tập trung hơn. Việc tạo ra một ID duy nhất khiến việc các oracles thông đồng và thao túng giá cho một yêu cầu cụ thể trở nên khó khăn hơn.

Nói cách khác, bạn cần tạo ra một số ngẫu nhiên.

Nhưng làm thế nào để tạo ra một số ngẫu nhiên trong Solidity?

Một giải pháp là để một con zombie ngẫu nhiên gõ bàn phím. Nhưng con zombie tội nghiệp cũng sẽ gõ khoảng trắng và ký tự, do đó "số ngẫu nhiên" của bạn có thể trông giống như: erkljf3r4398r4390r830.

Dù vậy, ngay cả khi không có con zombie nào bị thương trong bài học này, giải pháp này để tạo số ngẫu nhiên thực sự không hiệu quả😎.

Tuy nhiên, trong Solidity, bạn có thể tính toán một số ngẫu nhiên "đủ tốt" bằng cách sử dụng hàm keccak256 như sau:

solidity

uint randNonce = 0;
uint modulus = 1000;
uint randomNumber = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % modulus;
Đoạn mã trên lấy dấu thời gian now, msg.sender (địa chỉ của người gửi), và một nonce (một số chỉ được sử dụng một lần, để tránh việc chạy lại hàm băm với cùng tham số đầu vào). Sau đó, nó đóng gói các đầu vào và sử dụng keccak256 để chuyển đổi chúng thành một băm ngẫu nhiên. Tiếp theo, nó chuyển băm thành một uint. Cuối cùng, nó sử dụng % modulus để chỉ lấy ba chữ số cuối. Điều này cho phép bạn có một số ngẫu nhiên "đủ tốt" từ 0 đến modulus.

Bài học 4 sẽ giải thích tại sao phương pháp này không hoàn toàn an toàn 100% và cung cấp một số lựa chọn thay thế để tạo ra số ngẫu nhiên an toàn hơn. Hãy đọc qua bài học đó sau khi hoàn thành bài này.

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
  // Start here
  function getLatestEthPrice()public returns (uint256) {
    randNonce++;
    uint id = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce)))%modulus;
  }
}
