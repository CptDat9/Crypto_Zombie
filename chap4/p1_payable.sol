/*
Chương 1: Payable
Cho đến nay, chúng ta đã đề cập đến khá nhiều bộ sửa đổi (modifiers) trong hàm. Có thể sẽ khó nhớ hết mọi thứ, vì vậy hãy điểm qua một số khái niệm nhanh:

Visibility modifiers: kiểm soát khi nào và từ đâu có thể gọi hàm. private có nghĩa là chỉ có thể gọi từ các hàm khác trong cùng hợp đồng; internal giống như private nhưng có thể được gọi từ các hợp đồng kế thừa; external chỉ có thể được gọi từ bên ngoài hợp đồng; và cuối cùng, public có thể được gọi từ bất kỳ đâu, cả bên trong và bên ngoài.

State modifiers: cho biết hàm tương tác với Blockchain như thế nào. view cho biết hàm không lưu hoặc thay đổi dữ liệu khi chạy. pure cho biết hàm không chỉ không lưu dữ liệu mà còn không đọc dữ liệu từ Blockchain. Cả hai loại này không tốn gas khi gọi từ bên ngoài hợp đồng (nhưng tốn gas nếu gọi từ một hàm khác trong hợp đồng).

Custom modifiers: Chúng ta đã học trong Bài học 3, chẳng hạn như onlyOwner và aboveLevel. Những bộ sửa đổi này cho phép ta định nghĩa logic tùy chỉnh để xác định cách chúng ảnh hưởng đến một hàm.

Các modifiers này có thể được kết hợp với nhau trong một định nghĩa hàm như sau:

solidity
function test() external view onlyOwner anotherModifier { /* ... */ }
Modifier payable
Bây giờ chúng ta sẽ giới thiệu thêm một bộ sửa đổi nữa: payable.

Hàm payable là một phần đặc biệt giúp Solidity và Ethereum trở nên thú vị — đây là loại hàm đặc biệt có thể nhận Ether.

Hãy suy nghĩ về điều này: Khi bạn gọi một hàm API trên một máy chủ web thông thường, bạn không thể gửi kèm theo đô la Mỹ hoặc Bitcoin. Nhưng trong Ethereum, vì tiền (Ether), dữ liệu (payload giao dịch), và mã hợp đồng đều tồn tại trên Ethereum,
bạn có thể gọi một hàm và gửi tiền vào hợp đồng cùng lúc.

Điều này mở ra nhiều logic thú vị, như yêu cầu một khoản thanh toán cụ thể để thực thi một hàm.

Ví dụ:

solidity
contract OnlineStore {
  function buySomething() external payable {
    // Kiểm tra xem có đúng 0.001 ether được gửi đến hàm không:
    require(msg.value == 0.001 ether);
    // Nếu đúng, chuyển đổi một mặt hàng kỹ thuật số cho người gọi hàm:
    transferThing(msg.sender);
  }
}
Ở đây, msg.value là cách để xem bao nhiêu Ether đã được gửi đến hợp đồng, và ether là một đơn vị tích hợp sẵn.

Điều gì xảy ra ở đây là một người sẽ gọi hàm từ web3.js (từ giao diện JavaScript của DApp) như sau:

javascript
// Giả sử `OnlineStore` trỏ đến hợp đồng của bạn trên Ethereum:
OnlineStore.buySomething({from: web3.eth.defaultAccount, value: web3.utils.toWei(0.001)})
Lưu ý trường value, nơi hàm JavaScript xác định số Ether được gửi (0.001). Nếu bạn nghĩ về giao dịch như một phong bì, và các tham số bạn gửi vào hàm là nội dung của bức thư, thì việc thêm value giống như đặt tiền mặt vào phong bì — thư và tiền được gửi cùng nhau đến người nhận.

Lưu ý: Nếu một hàm không được đánh dấu payable và bạn cố gắng gửi Ether đến hàm đó như ví dụ trên, hàm sẽ từ chối giao dịch của bạn.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  // 1. Define levelUpFee here
uint levelUpFee = 0.001 ether;
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // 2. Insert levelUp function here
  function levelUp (uint _zombieId) external payable {
    require (msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
