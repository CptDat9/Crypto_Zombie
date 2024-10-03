/* 
Chương 3: msg.sender
Bây giờ chúng ta đã có mappings để theo dõi ai sở hữu một zombie, chúng ta sẽ muốn cập nhật phương thức _createZombie để sử dụng chúng.

Để làm điều này, chúng ta cần sử dụng một thứ gọi là msg.sender.

msg.sender
Trong Solidity, có một số biến toàn cục có sẵn cho tất cả các hàm. Một trong số đó là msg.sender, tham chiếu đến địa chỉ của người (hoặc hợp đồng thông minh) đã gọi hàm hiện tại.

Lưu ý: Trong Solidity, việc thực thi hàm luôn cần phải bắt đầu với một người gọi bên ngoài. Một hợp đồng sẽ chỉ ngồi trên blockchain mà không làm gì cho đến khi có ai đó gọi một trong các hàm của nó. Vì vậy, sẽ luôn có một msg.sender.

Dưới đây là một ví dụ về việc sử dụng msg.sender và cập nhật một mapping:

solidity
mapping (address => uint) favoriteNumber;

function setMyNumber(uint _myNumber) public {
  // Cập nhật mapping `favoriteNumber` để lưu trữ `_myNumber` cho `msg.sender`
  favoriteNumber[msg.sender] = _myNumber;
  // ^ Cú pháp để lưu trữ dữ liệu trong một mapping giống như với mảng
}

function whatIsMyNumber() public view returns (uint) {
  // Truy xuất giá trị được lưu trữ tại địa chỉ của người gọi
  // Sẽ trả về `0` nếu người gọi chưa gọi `setMyNumber`
  return favoriteNumber[msg.sender];
}
Trong ví dụ đơn giản này, bất kỳ ai cũng có thể gọi setMyNumber và lưu trữ một số nguyên uint vào hợp đồng của chúng ta, số này sẽ được liên kết với địa chỉ của họ. Sau đó, khi họ gọi whatIsMyNumber, họ sẽ nhận lại giá trị uint mà họ đã lưu trữ.

Sử dụng msg.sender cung cấp cho bạn tính bảo mật của blockchain Ethereum — cách duy nhất để ai đó có thể sửa đổi dữ liệu của người khác là phải đánh cắp khóa riêng liên kết với địa chỉ Ethereum của họ.
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
        zombieToOwner[id]=msg.sender;
        ownerZombieCount[msg.sender]++;
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
