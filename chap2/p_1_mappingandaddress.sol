/*
Chương 2: Mappings và Địa chỉ
Hãy làm cho trò chơi của chúng ta trở thành nhiều người chơi bằng cách gán cho các zombie trong cơ sở dữ liệu một người chủ sở hữu.

Để làm điều này, chúng ta sẽ cần hai kiểu dữ liệu mới: mapping và address.

Địa chỉ (Addresses)
Blockchain của Ethereum được tạo thành từ các tài khoản, bạn có thể hình dung chúng như các tài khoản ngân hàng. Mỗi tài khoản có một số dư Ether (đơn vị tiền tệ được sử dụng trên blockchain Ethereum), và bạn có thể gửi và nhận các khoản thanh toán Ether tới các tài khoản khác, giống như tài khoản ngân hàng của bạn có thể chuyển khoản tới các tài khoản ngân hàng khác.

Mỗi tài khoản có một địa chỉ, bạn có thể tưởng tượng nó như một số tài khoản ngân hàng. Đây là một mã định danh duy nhất chỉ đến tài khoản đó, và nó trông như thế này:

0x0cE446255506E92DF41614C46F1d6df9Cc969183

(Địa chỉ này thuộc về nhóm CryptoZombies. Nếu bạn đang tận hưởng CryptoZombies, bạn có thể gửi cho chúng tôi một chút Ether! 😉 )

Chúng ta sẽ đi sâu vào chi tiết của địa chỉ trong một bài học sau, nhưng hiện tại bạn chỉ cần hiểu rằng một địa chỉ thuộc về một người dùng cụ thể (hoặc một hợp đồng thông minh).

Vì vậy, chúng ta có thể sử dụng nó như một mã ID duy nhất để xác định quyền sở hữu của zombie. Khi một người dùng tạo ra zombie mới bằng cách tương tác với ứng dụng của chúng ta, chúng ta sẽ thiết lập quyền sở hữu của những zombie đó cho địa chỉ Ethereum đã gọi hàm đó.

Mappings
Trong Bài học 1, chúng ta đã tìm hiểu về structs và arrays. Mappings là một cách khác để lưu trữ dữ liệu có tổ chức trong Solidity.

Việc định nghĩa một mapping trông như thế này:

solidity
    // Dùng trong ứng dụng tài chính, lưu trữ một uint đại diện cho số dư tài khoản của người dùng:
mapping (address => uint) public accountBalance;

// Hoặc có thể dùng để lưu trữ / tra cứu tên người dùng dựa trên userId
mapping (uint => string) userIdToName;
Một mapping về cơ bản là một kho lưu trữ dạng khóa-giá trị để lưu trữ và tra cứu dữ liệu. Trong ví dụ đầu tiên, khóa là một địa chỉ và giá trị là một uint, còn trong ví dụ thứ hai, khóa là một uint và giá trị là một chuỗi ký tự.
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
    mapping(address => uint)  ownerZombieCount; 
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
