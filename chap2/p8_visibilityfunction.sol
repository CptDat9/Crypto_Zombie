/*
Chương 9: Tìm hiểu thêm về Tầm nhìn (Visibility) của Hàm
Code trong bài học trước có một lỗi!

Nếu bạn thử biên dịch nó, trình biên dịch sẽ báo lỗi.

Vấn đề là chúng ta đã cố gọi hàm _createZombie từ trong ZombieFeeding, nhưng _createZombie là một hàm private bên trong ZombieFactory. Điều này có nghĩa là không có hợp đồng nào kế thừa từ ZombieFactory có thể truy cập vào nó.

Internal và External
Ngoài public và private, Solidity còn có hai loại tầm nhìn khác cho hàm: internal (bên trong) và external(bên ngoài).

internal giống như private, nhưng nó cũng có thể được truy cập bởi các hợp đồng kế thừa từ hợp đồng hiện tại. (Đây chính là thứ chúng ta cần ở đây!).

external tương tự như public, nhưng các hàm này chỉ có thể được gọi từ bên ngoài hợp đồng — chúng không thể được gọi từ các hàm khác bên trong hợp đồng đó. Chúng ta sẽ thảo luận sau về lý do tại sao bạn có thể muốn sử dụng external thay vì public.

Để khai báo hàm internal hoặc external, cú pháp giống như với private và public:

solidity
contract Sandwich {
  uint private sandwichesEaten = 0;

  function eat() internal {
    sandwichesEaten++;
  }
}

contract BLT is Sandwich {
  uint private baconSandwichesEaten = 0;

  function eatWithBacon() public returns (string memory) {
    baconSandwichesEaten++;
    // Chúng ta có thể gọi hàm này ở đây vì nó là internal
    eat();
  }
}
Trong ví dụ này, vì hàm eat() được khai báo là internal, hợp đồng BLT, vốn kế thừa từ Sandwich, có thể gọi được hàm eat().
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

    // edit function definition below
    function _createZombie(string memory _name, uint _dna) internal {
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
