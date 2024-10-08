/*
Chương 7: Các hàm Public và Bảo mật
Bây giờ hãy sửa đổi hàm feedAndMultiply để tính đến thời gian hồi phục (cooldown timer).

Nhìn lại hàm này, bạn có thể thấy rằng chúng ta đã đặt nó là public trong bài học trước. Một thực hành bảo mật quan trọng là phải xem xét tất cả các hàm public và external, 
sau đó cố gắng suy nghĩ về cách mà người dùng có thể lạm dụng chúng. Hãy nhớ rằng — trừ khi các hàm này có một bộ sửa đổi (modifier) như onlyOwner, bất kỳ người dùng nào cũng có thể gọi chúng và truyền bất kỳ dữ liệu nào họ muốn.

Xem xét kỹ hơn hàm này, người dùng có thể gọi hàm trực tiếp và truyền vào bất kỳ _targetDna hoặc _species nào họ muốn. Điều này không giống với cách chơi game — chúng ta muốn họ tuân thủ các quy tắc của mình!

Sau khi kiểm tra kỹ, hàm này chỉ cần được gọi bởi hàm feedOnKitty(), vì vậy cách dễ nhất để ngăn chặn các lỗ hổng này là đặt nó thành internal.
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

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  // 1. Make this function internal
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    // 2. Add a check for `_isReady` here
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    // 3. Call `_triggerCooldown`
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
