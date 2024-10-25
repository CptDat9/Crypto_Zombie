/*
Chương 6: Thời gian chờ hồi phục của Zombie
Bây giờ khi chúng ta đã có thuộc tính readyTime trong struct Zombie, hãy chuyển sang tập tin zombiefeeding.sol và triển khai bộ đếm thời gian hồi phục.

Chúng ta sẽ sửa đổi hàm feedAndMultiply như sau:

Việc cho ăn sẽ kích hoạt thời gian hồi phục của zombie, và
Zombie không thể tiếp tục ăn mèo con (kitties) cho đến khi thời gian hồi phục kết thúc.
Điều này sẽ ngăn zombie ăn vô hạn mèo con và nhân bản liên tục suốt cả ngày. Trong tương lai, khi chúng ta thêm tính năng chiến đấu, việc tấn công các zombie khác cũng sẽ dựa trên thời gian hồi phục.

Trước tiên, chúng ta sẽ định nghĩa một số hàm trợ giúp để đặt và kiểm tra thời gian sẵn sàng (readyTime) của zombie.

Truyền struct làm tham số

Bạn có thể truyền một con trỏ lưu trữ (storage pointer) của một struct làm tham số cho một hàm private hoặc internal. Điều này rất hữu ích, ví dụ như khi truyền struct Zombie của chúng ta giữa các hàm.

Cú pháp như sau:

solidity
function _doStuff(Zombie storage _zombie) internal {
  // thực hiện công việc với _zombie
}
Bằng cách này, chúng ta có thể truyền một tham chiếu tới zombie vào trong hàm thay vì truyền ID của zombie và phải tìm kiếm nó.
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

  // 1. Define `_triggerCooldown` function here
  function _triggerCooldown(Zombie storage _zombie) internal
{
      _zombie.readyTime = uint32(now + cooldownTime);
}
  // 2. Define `_isReady` function here
  function _isReady(Zombie storage _zombie) internal view returns (bool) {
// NHớ là returns nhé chứ không phải return thông thường và phải đóng ngoặc sau khi return còn body hàm viết là return
    return (_zombie.readyTime <= now);
  }
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
