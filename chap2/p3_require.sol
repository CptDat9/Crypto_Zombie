/*
Chương 4: Require
Trong bài học 1, chúng ta đã làm cho người dùng có thể tạo zombie mới bằng cách gọi hàm createRandomZombie và nhập tên. Tuy nhiên, nếu người dùng có thể liên tục gọi hàm này để tạo ra vô số zombie cho quân đội của họ, trò chơi sẽ không còn thú vị.

Hãy làm cho mỗi người chơi chỉ có thể gọi hàm này một lần. Bằng cách đó, người chơi mới sẽ gọi hàm khi họ lần đầu bắt đầu trò chơi để tạo zombie ban đầu cho đội quân của họ.

Làm thế nào để đảm bảo rằng hàm này chỉ có thể được gọi một lần cho mỗi người chơi?

Để làm điều này, chúng ta sử dụng require. require giúp hàm ném ra một lỗi và dừng thực thi nếu một điều kiện nào đó không đúng:

solidity
function sayHiToVitalik(string memory _name) public returns (string memory) {
  // So sánh nếu _name bằng "Vitalik". Ném ra lỗi và thoát nếu không đúng.
  // (Chú thích: Solidity không có so sánh chuỗi bản địa, vì vậy chúng ta 
  P/s: việc so sánh chuỗi bản địa tức là so sánh trực tiếp 2 chuỗi với nhau.
  VD: Trong Python: "abc" == "abc".
  Ở solidity ta phải so sánh các hash keccak256 để xem chuỗi có bằng nhau ko ?
  // so sánh các hash keccak256 của chúng để xem chuỗi có bằng nhau không)
  require(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Vitalik")));
  // Nếu đúng, tiếp tục thực thi hàm:
  return "Hi!";
}
Nếu bạn gọi hàm này với sayHiToVitalik("Vitalik"), nó sẽ trả về "Hi!". Nếu bạn gọi nó với bất kỳ đầu vào nào khác, nó sẽ ném ra lỗi và không thực thi.

Do đó, require rất hữu ích để kiểm tra các điều kiện nhất định cần phải đúng trước khi chạy một hàm.
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
        // start here
        require(ownerZombieCount[msg.sender]==0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
