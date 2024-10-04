/*
Chương 8: Zombie DNA
Hãy hoàn thành hàm feedAndMultiply.

Công thức để tính toán DNA của zombie mới rất đơn giản: đó là trung bình cộng giữa DNA của zombie đang cho ăn và DNA của mục tiêu.

Ví dụ:

solidity
function testDnaSplicing() public {
  uint zombieDna = 2222222222222222;
  uint targetDna = 4444444444444444;
  uint newZombieDna = (zombieDna + targetDna) / 2;
  // ^ sẽ bằng 3333333333333333
}
Sau này, chúng ta có thể làm cho công thức này phức tạp hơn nếu muốn, như là thêm yếu tố ngẫu nhiên vào DNA của zombie mới. Nhưng hiện tại chúng ta sẽ giữ nó đơn giản — sau này chúng ta luôn có thể quay lại và chỉnh sửa.
*/

pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    // start here
    _targetDna= _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna)/2;
    _createZombie("NoName", newDna);
  }

}
