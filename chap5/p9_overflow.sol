Chương 9: Ngăn ngừa tràn số (Overflow)
Chúc mừng, bạn đã hoàn thành việc triển khai ERC721 và ERC721x!

Điều này không quá khó, đúng không? Ethereum có thể nghe rất phức tạp, nhưng cách tốt nhất để hiểu là thực hiện một triển khai thực tế như bạn vừa làm.

Lưu ý rằng đây chỉ là một phiên bản triển khai tối thiểu. Có thể sẽ có những tính năng bổ sung mà chúng ta muốn thêm vào, 
như việc kiểm tra để đảm bảo người dùng không vô tình chuyển zombie của họ tới địa chỉ 0 (điều này được gọi là "đốt" token — nghĩa là nó được gửi tới địa chỉ không có ai giữ khóa riêng, khiến nó không thể khôi phục).
Hoặc có thể thêm một số logic đấu giá cơ bản vào ứng dụng DApp. (Bạn có nghĩ ra cách nào để triển khai điều đó không?)

Nhưng để giữ bài học trong tầm kiểm soát, chúng ta đã thực hiện một phiên bản đơn giản nhất.
Nếu bạn muốn xem một ví dụ về triển khai chi tiết hơn, hãy xem hợp đồng ERC721 của OpenZeppelin sau khi hoàn thành bài hướng dẫn này.

Cải thiện bảo mật hợp đồng: Tràn số và thiếu số
Chúng ta sẽ xem xét một tính năng bảo mật quan trọng khi viết smart contract: Ngăn ngừa tràn số (overflow) và thiếu số (underflow).

Tràn số là gì?
Giả sử chúng ta có một biến uint8, chỉ có thể chứa 8 bit. Điều đó có nghĩa là số lớn nhất có thể lưu trữ là nhị phân 11111111 (hoặc ở hệ thập phân là 2^8 - 1 = 255).

Hãy xem đoạn mã sau. Sau khi thực hiện, giá trị của number sẽ là bao nhiêu?

solidity
uint8 number = 255;
number++;
Trong trường hợp này, chúng ta đã gây ra tràn số — giá trị của number bây giờ sẽ bằng 0 mặc dù ta đã tăng nó lên (khi bạn cộng 1 vào 11111111 nhị phân, nó sẽ quay về 00000000, giống như đồng hồ từ 23:59 về 00:00).

Thiếu số cũng tương tự, khi bạn trừ 1 từ một uint8 có giá trị là 0, nó sẽ thành 255 (vì uint là số không dấu, không thể mang giá trị âm).

Mặc dù chúng ta không sử dụng uint8 ở đây, và có vẻ khó xảy ra việc tràn số với uint256 khi chỉ tăng lên 1 mỗi lần (2^256 là một số rất lớn),
nhưng vẫn tốt nếu có các biện pháp bảo vệ để DApp của chúng ta không gặp phải hành vi không mong muốn trong tương lai.

Sử dụng SafeMath
Để ngăn ngừa điều này, OpenZeppelin đã tạo ra một thư viện gọi là SafeMath, giúp ngăn chặn các vấn đề này mặc định.

Trước khi tìm hiểu chi tiết... Thư viện là gì?

Thư viện là một loại hợp đồng đặc biệt trong Solidity. Một trong những tính năng của nó là cho phép gắn các hàm vào kiểu dữ liệu gốc.

Ví dụ, với thư viện SafeMath, chúng ta sẽ sử dụng cú pháp using SafeMath for uint256. Thư viện SafeMath có 4 hàm — add, sub, mul, và div. Và bây giờ chúng ta có thể truy cập các hàm này từ uint256 như sau:

solidity
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10
Chúng ta sẽ xem xét chi tiết các hàm này trong chương tiếp theo, nhưng trước hết, hãy thêm thư viện SafeMath vào hợp đồng của chúng ta.
----------------------------------------------------------------------------------
pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
// 1. Import here
import "./safemath.sol";
contract ZombieFactory is Ownable {

  // 2. Declare using safemath here
using SafeMath for uint256;

  event NewZombie(uint zombieId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Zombie[] public zombies;

  mapping (uint => address) public zombieToOwner;
  mapping (address => uint) ownerZombieCount;

  function _createZombie(string memory _name, uint _dna) internal {
    uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
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
    randDna = randDna - randDna % 100;
    _createZombie(_name, randDna);
  }

}





