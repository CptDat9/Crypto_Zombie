/*
Chương 5: Kế thừa

Code trò chơi của chúng ta đang trở nên khá dài. Thay vì viết một contract quá dài, đôi khi việc chia nhỏ logic code của bạn thành nhiều contract khác nhau sẽ giúp tổ chức mã một cách hợp lý hơn.

Một tính năng của Solidity giúp việc này dễ quản lý hơn là kế thừa contract:

solidity
contract Doge {
  function catchphrase() public returns (string memory) {
    return "So Wow CryptoDoge";
  }
}

contract BabyDoge is Doge {
  function anotherCatchphrase() public returns (string memory) {
    return "Such Moon BabyDoge";
  }
}
Contract BabyDoge kế thừa từ Doge. Điều này có nghĩa là nếu bạn biên dịch và triển khai BabyDoge, nó sẽ có quyền truy cập cả hai hàm catchphrase() và anotherCatchphrase() (và bất kỳ hàm public nào khác mà chúng ta có thể định nghĩa trong Doge).

Điều này có thể được sử dụng cho kế thừa logic (chẳng hạn như với một lớp con, một con Mèo là một con Vật). Nhưng nó cũng có thể được sử dụng để tổ chức mã bằng cách nhóm các logic tương tự vào các contract khác nhau.
*/
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

contract ZombieFeeding is ZombieFactory
{
    
}
