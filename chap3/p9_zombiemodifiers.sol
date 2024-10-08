/*
Chương 9: Zombie Modifiers

Bây giờ chúng ta sẽ sử dụng modifier aboveLevel để tạo một số hàm.

Trong trò chơi của chúng ta, sẽ có một số động lực khuyến khích người chơi nâng cấp zombie của họ:

Với zombie từ cấp 2 trở lên, người chơi sẽ có thể thay đổi tên.
Với zombie từ cấp 20 trở lên, người chơi sẽ có thể thay đổi DNA của chúng.
Chúng ta sẽ triển khai các chức năng này ở bên dưới. Dưới đây là ví dụ mã từ bài học trước để tham khảo:

solidity
// Một mapping để lưu trữ tuổi của người dùng:
mapping (uint => uint) public age;

// Yêu cầu rằng người dùng này phải lớn hơn một độ tuổi nhất định:
modifier olderThan(uint _age, uint _userId) {
  require(age[_userId] >= _age);
  _;
}

// Phải lớn hơn 16 tuổi để lái xe (ít nhất là ở Mỹ)
function driveCar(uint _userId) public olderThan(16, _userId) {
  // Một số logic của hàm
}
Chúng ta sẽ tiếp tục triển khai dựa trên ví dụ này để phát triển thêm các tính năng cho trò chơi.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // Start here
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  function changeDna (uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId)
  { 
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna= _newDna;
  }

}





