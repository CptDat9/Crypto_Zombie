/*
Chương 11: Sử dụng một Interface (Giao diện)

Tiếp tục ví dụ trước của chúng ta với NumberInterface, sau khi chúng ta đã định nghĩa giao diện như sau:

solidity
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
Chúng ta có thể sử dụng nó trong một hợp đồng (contract) như sau:

solidity
contract MyContract {
  address NumberInterfaceAddress = 0xab38...;
  // ^ Đây là địa chỉ của hợp đồng FavoriteNumber trên Ethereum
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress);
  // Bây giờ `numberContract` đang trỏ đến hợp đồng khác

  function someFunction() public {
    // Bây giờ chúng ta có thể gọi `getNum` từ hợp đồng đó:
    uint num = numberContract.getNum(msg.sender);
    // ...và làm gì đó với `num` ở đây
  }
}
Bằng cách này, hợp đồng của bạn có thể tương tác với bất kỳ hợp đồng nào khác trên blockchain Ethereum, miễn là chúng cung cấp các hàm đó dưới dạng public (công khai) hoặc external (ngoại vi).
*/pragma solidity >=0.5.0 <0.6.0;

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
  // Initialize kittyContract here using `ckAddress` from above
KittyInterface kittyContract=KittyInterface(ckAddress);
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}
