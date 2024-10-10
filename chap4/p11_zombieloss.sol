/*
Chương 11: Zombie thua 😞
Bây giờ chúng ta đã lập trình phần zombie chiến thắng, hãy tìm hiểu điều gì sẽ xảy ra khi chúng thua.

Trong trò chơi của chúng ta, khi zombie thua, chúng không bị giảm cấp — chúng chỉ thêm một lần thua vào lossCount, và kích hoạt thời gian chờ (cooldown), khiến chúng phải đợi một ngày trước khi tấn công lại.

Để triển khai logic này, chúng ta sẽ cần một câu lệnh else.

Câu lệnh else được viết giống như trong JavaScript và nhiều ngôn ngữ khác:

javascript
Sao chép mã
if (zombieCoins[msg.sender] > 100000000) {
  // Bạn rất giàu!!!
} else {
  // Chúng tôi cần thêm ZombieCoins...
}
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiehelper.sol";

contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external ownerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myZombie.winCount++;
      myZombie.level++;
      enemyZombie.lossCount++;
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } // start here
    else
    {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      _triggerCooldown(myZombie);
    }
  }
}
