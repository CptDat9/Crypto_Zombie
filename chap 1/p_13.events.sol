/*
Chương 13: Sự kiện

Hợp đồng của chúng ta gần hoàn thành rồi! Giờ hãy thêm một sự kiện (event).

Sự kiện là cách để hợp đồng thông báo rằng một điều gì đó đã xảy ra trên blockchain cho ứng dụng front-end của bạn, ứng dụng này có thể 'lắng nghe' các sự kiện nhất định và thực hiện hành động khi sự kiện đó xảy ra.

Ví dụ:

solidity
// khai báo sự kiện
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public returns (uint) {
  uint result = _x + _y;
  // kích hoạt sự kiện để ứng dụng biết rằng hàm đã được gọi:
  emit IntegersAdded(_x, _y, result);
  return result;
}
Ứng dụng front-end của bạn sau đó có thể lắng nghe sự kiện.
Một ví dụ triển khai JavaScript trông sẽ như thế này:

javascript
YourContract.IntegersAdded(function(error, result) {
  // thực hiện hành động với kết quả
});
*/
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {
    // declare our event here
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
         uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);     
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }


}
