/
Chương 12: Vòng lặp For

Trong chương trước, chúng ta đã đề cập rằng đôi khi bạn sẽ muốn sử dụng vòng lặp for để tạo nội dung cho một mảng trong hàm thay vì đơn giản chỉ lưu mảng đó vào bộ nhớ.

Hãy xem lý do tại sao.

Đối với hàm getZombiesByOwner, một cách triển khai đơn giản là lưu một ánh xạ giữa chủ sở hữu và đội quân zombie trong hợp đồng ZombieFactory:

solidity
Sao chép mã
mapping (address => uint[]) public ownerToZombies
Sau đó, mỗi khi tạo ra một zombie mới, chúng ta chỉ cần sử dụng ownerToZombies[owner].push(zombieId) để thêm zombie đó vào mảng zombie của chủ sở hữu. Và hàm getZombiesByOwner sẽ rất đơn giản:

solidity
Sao chép mã
function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
  return ownerToZombies[_owner];
}
Vấn đề với cách tiếp cận này

Cách tiếp cận này rất hấp dẫn vì sự đơn giản của nó. Nhưng hãy xem điều gì sẽ xảy ra nếu sau đó chúng ta thêm một hàm để chuyển một zombie từ chủ sở hữu này sang chủ sở hữu khác (điều mà chúng ta chắc chắn sẽ thêm vào ở bài học sau!).

Hàm chuyển đổi đó sẽ cần:

Đẩy zombie vào mảng ownerToZombies của chủ sở hữu mới,
Loại bỏ zombie khỏi mảng ownerToZombies của chủ sở hữu cũ,
Dịch chuyển tất cả zombie trong mảng của chủ sở hữu cũ lên một vị trí để lấp đầy khoảng trống, và sau đó
Giảm độ dài mảng đi 1.
Bước 3 sẽ rất tốn kém về gas, vì chúng ta sẽ phải ghi lại cho mỗi zombie mà chúng ta di chuyển vị trí.
Nếu một chủ sở hữu có 20 zombie và trao đổi zombie đầu tiên, chúng ta sẽ phải thực hiện 19 lần ghi để duy trì thứ tự của mảng.

Vì ghi vào bộ nhớ là một trong những thao tác tốn kém nhất trong Solidity, mỗi lần gọi hàm chuyển đổi này sẽ rất tốn gas. 
Tệ hơn, số lượng gas sẽ khác nhau mỗi lần gọi, phụ thuộc vào số lượng zombie mà người dùng có và vị trí của zombie được giao dịch. Do đó, người dùng sẽ không biết cần gửi bao nhiêu gas.

Lưu ý: Tất nhiên, chúng ta có thể chỉ cần di chuyển zombie cuối cùng trong mảng để lấp đầy chỗ trống và giảm độ dài mảng đi một.
Nhưng điều đó sẽ thay đổi thứ tự của đội quân zombie mỗi khi chúng ta thực hiện một giao dịch.

Vì các hàm view không tốn gas khi được gọi từ bên ngoài, chúng ta có thể sử dụng vòng lặp for trong hàm getZombiesByOwner để duyệt qua toàn bộ mảng zombie và tạo một mảng gồm các zombie thuộc về chủ sở hữu cụ thể này. 
Sau đó, hàm chuyển đổi của chúng ta sẽ rẻ hơn nhiều, vì chúng ta không cần phải sắp xếp lại bất kỳ mảng nào trong bộ nhớ, và điều này thực sự tiết kiệm hơn.

Sử dụng vòng lặp for

Cú pháp của vòng lặp for trong Solidity tương tự như JavaScript.

Hãy xem một ví dụ trong đó chúng ta muốn tạo một mảng gồm các số chẵn:

solidity
function getEvens() pure external returns(uint[] memory) {
  uint;
  // Theo dõi chỉ số trong mảng mới:
  uint counter = 0;
  // Duyệt từ 1 đến 10 bằng vòng lặp for:
  for (uint i = 1; i <= 10; i++) {
    // Nếu `i` là số chẵn...
    if (i % 2 == 0) {
      // Thêm nó vào mảng
      evens[counter] = i;
      // Tăng chỉ số lên vị trí trống tiếp theo trong `evens`:
      counter++;
    }
  }
  
  return evens;
}
Hàm này sẽ trả về một mảng có nội dung [2, 4, 6, 8, 10].
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
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
    // Start here
    uint counter = 0;
    for (uint i =0; i < zombies.length; i++)
    {
      if (zombieToOwner[i] == _owner)
      {
        result[counter]=i;
        counter++;
      }
    }
    return result;
  }

}
