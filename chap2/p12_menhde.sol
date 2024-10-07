/*
Chương 13: Bonus: Gen của Kitty

Logic của hàm đã hoàn thành... nhưng hãy thêm một tính năng bonus.

Chúng ta sẽ làm cho những zombie được tạo ra từ kitties có một đặc điểm độc đáo để cho thấy chúng là cat-zombies.

Để làm điều này, chúng ta có thể thêm một mã đặc biệt của kitty vào trong DNA của zombie.

Nếu bạn còn nhớ từ bài học 1, chúng ta hiện chỉ sử dụng 12 chữ số đầu tiên của DNA 16 chữ số để xác định hình dáng của zombie. Vậy nên chúng ta sẽ sử dụng 2 chữ số cuối chưa được dùng để xử lý các đặc điểm "đặc biệt".

Chúng ta sẽ nói rằng cat-zombies có 99 là hai chữ số cuối cùng của DNA (vì mèo có 9 mạng sống). Vậy trong mã của chúng ta, nếu một zombie xuất phát từ mèo, thì chúng ta sẽ đặt hai chữ số cuối của DNA thành 99.

Câu lệnh If
Các câu lệnh if trong Solidity trông giống như trong JavaScript:

solidity
function eatBLT(string memory sandwich) public {
  // Nhớ rằng với chuỗi, chúng ta phải so sánh các hàm băm keccak256
  // để kiểm tra sự bằng nhau
  if (keccak256(abi.encodePacked(sandwich)) == keccak256(abi.encodePacked("BLT"))) {
    eat();
  }
}
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna,string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
      newDna = newDna - newDna%100 + 99;
    }   
     _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);

    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
