/*
Chương 4: Số ngẫu nhiên

Tuyệt vời! Giờ thì chúng ta hãy tìm hiểu về logic trận đấu.

Tất cả các trò chơi hay đều cần một mức độ ngẫu nhiên nhất định. Vậy làm thế nào để tạo ra số ngẫu nhiên trong Solidity?

Câu trả lời thực sự ở đây là: bạn không thể. Ít nhất là bạn không thể làm điều đó một cách an toàn.

Hãy cùng xem tại sao.

Tạo số ngẫu nhiên thông qua hàm keccak256
Nguồn tạo ngẫu nhiên tốt nhất mà chúng ta có trong Solidity là hàm băm keccak256.

Chúng ta có thể làm điều gì đó như sau để tạo một số ngẫu nhiên:

solidity
// Tạo số ngẫu nhiên từ 1 đến 100:
uint randNonce = 0;
uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
randNonce++;
uint random2 = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
Điều này sẽ lấy dấu thời gian của now, msg.sender, và một nonce tăng dần (một số chỉ được sử dụng một lần, để tránh việc chạy hàm băm với cùng một tham số đầu vào hai lần).

Nó sẽ "đóng gói" các đầu vào và sử dụng keccak để chuyển đổi chúng thành một băm ngẫu nhiên. Tiếp theo, nó sẽ chuyển đổi băm đó thành một số kiểu uint,
và sau đó sử dụng % 100 để lấy chỉ hai chữ số cuối. Điều này sẽ cho chúng ta một số ngẫu nhiên trong khoảng từ 0 đến 99.

Phương pháp này dễ bị tấn công bởi một node không trung thực
Trong Ethereum, khi bạn gọi một hàm trên hợp đồng, bạn phát sóng nó đến một hoặc nhiều node trên mạng dưới dạng một giao dịch. 
Các node trên mạng sau đó thu thập một loạt các giao dịch, cố gắng là người đầu tiên giải quyết một bài toán tính toán phức tạp như một "Bằng chứng công việc" (Proof of Work), 
và sau đó công bố nhóm giao dịch đó cùng với bằng chứng công việc của họ dưới dạng một khối cho phần còn lại của mạng.

Khi một node đã giải quyết được bằng chứng công việc, các node khác ngừng cố gắng giải quyết, 
xác minh danh sách giao dịch của node kia và sau đó chấp nhận khối đó để tiếp tục giải quyết khối tiếp theo.

Điều này khiến hàm số ngẫu nhiên của chúng ta có thể bị khai thác.

Giả sử chúng ta có một hợp đồng tung đồng xu — mặt ngửa bạn gấp đôi số tiền, mặt sấp bạn mất hết. Giả sử nó sử dụng hàm ngẫu nhiên ở trên để xác định mặt ngửa hay sấp. (random >= 50 là mặt ngửa, random < 50 là mặt sấp).

Nếu tôi điều hành một node, tôi có thể phát hành một giao dịch chỉ cho node của mình và không chia sẻ nó. T
ôi có thể sau đó chạy hàm tung đồng xu để xem tôi có thắng hay không — và nếu tôi thua, tôi chọn không bao gồm giao dịch đó trong khối tiếp theo mà tôi đang giải quyết.
Tôi có thể tiếp tục làm điều này vô thời hạn cho đến khi tôi thắng và giải quyết khối tiếp theo, và kiếm lợi nhuận.

Vậy làm sao để tạo số ngẫu nhiên an toàn trong Ethereum?
Vì toàn bộ nội dung của blockchain đều có thể nhìn thấy bởi tất cả người tham gia, đây là một vấn đề khó, và giải pháp cho nó nằm ngoài phạm vi của hướng dẫn này.
Bạn có thể đọc qua chủ đề trên StackOverflow để tìm hiểu thêm một số ý tưởng. Một ý tưởng là sử dụng một oracle để truy cập một hàm số ngẫu nhiên từ bên ngoài blockchain Ethereum.

Tất nhiên, vì có hàng chục nghìn node Ethereum trên mạng đang cạnh tranh để giải quyết khối tiếp theo, khả năng tôi giải quyết khối tiếp theo là cực kỳ thấp.
Nó sẽ tốn rất nhiều thời gian hoặc tài nguyên tính toán để khai thác điều này một cách có lợi nhuận — nhưng nếu phần thưởng đủ cao (chẳng hạn như nếu tôi có thể đặt cược 100 triệu đô la vào hàm tung đồng xu), thì nó sẽ xứng đáng để tôi tấn công.

Vì vậy, mặc dù việc tạo số ngẫu nhiên này KHÔNG an toàn trên Ethereum, trong thực tế, trừ khi hàm ngẫu nhiên của chúng ta có rất nhiều tiền cược, người dùng trò chơi của bạn có lẽ sẽ không có đủ tài nguyên để tấn công nó.

Vì chúng ta chỉ đang xây dựng một trò chơi đơn giản để demo trong hướng dẫn này và không có tiền thật liên quan, chúng ta sẽ chấp nhận những thỏa hiệp của việc sử dụng một trình tạo số ngẫu nhiên đơn giản, biết rằng nó không hoàn toàn an toàn.

Trong một bài học tương lai, chúng ta có thể sẽ đề cập đến việc sử dụng các oracle (một cách an toàn để lấy dữ liệu từ bên ngoài Ethereum) để tạo số ngẫu nhiên an toàn từ bên ngoài blockchain.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  // Start here
  uint randNonce = 0;
  function randMod (uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now,msg.sender,randNonce)))% _modulus;
  }
}
