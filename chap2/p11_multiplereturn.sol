/*
Chương 12: Xử lý nhiều giá trị trả về

Hàm getKitty này là ví dụ đầu tiên chúng ta thấy trả về nhiều giá trị. Hãy xem cách xử lý chúng:

solidity
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // Đây là cách gán nhiều giá trị cùng lúc:
  (a, b, c) = multipleReturns();
}
// Hoặc nếu chúng ta chỉ quan tâm đến một trong các giá trị:

solidity
function getLastReturnValue() external {
  uint c;
  // Chúng ta có thể để trống các trường khác:
  (,,c) = multipleReturns();
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

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

  // define function here
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    // Ở đây ta quan tâm đến genes nên ta bỏ trống (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId); vì ta chỉ quan tâm đến kittyDna trong phần hàm của Contract kittyInterface;
    feedAndMultiply(_zombieId, kittyDna);
  }
}
