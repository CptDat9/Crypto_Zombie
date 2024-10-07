/*
Chương 4: Gas

Tuyệt! Giờ chúng ta đã biết cách cập nhật các phần chính của DApp trong khi ngăn người dùng khác can thiệp vào hợp đồng của chúng ta.

Hãy xem một cách khác mà Solidity khác biệt so với các ngôn ngữ lập trình khác:

Gas — nhiên liệu mà các DApp trên Ethereum vận hành
Trong Solidity, người dùng của bạn phải trả tiền mỗi khi họ thực thi một hàm trên DApp của bạn bằng một loại tiền tệ gọi là gas. Người dùng mua gas bằng Ether (đơn vị tiền tệ trên Ethereum), do đó họ phải chi tiêu ETH để thực thi các hàm trên DApp của bạn.

Lượng gas cần thiết để thực thi một hàm phụ thuộc vào mức độ phức tạp của logic hàm đó. Mỗi phép toán riêng lẻ có một chi phí gas dựa trên lượng tài nguyên tính toán cần thiết để thực hiện 
(ví dụ: ghi dữ liệu vào bộ nhớ tốn nhiều gas hơn so với phép cộng hai số nguyên). Tổng chi phí gas của một hàm là tổng chi phí gas của tất cả các phép toán trong hàm đó.

Vì việc chạy hàm tốn tiền thật của người dùng, nên việc tối ưu hóa mã trở nên quan trọng hơn nhiều trong Ethereum so với các ngôn ngữ lập trình khác. Nếu mã của bạn không được tối ưu, 
người dùng sẽ phải trả phí cao hơn để thực thi các hàm — điều này có thể dẫn đến hàng triệu đô la phí không cần thiết từ hàng ngàn người dùng.

Tại sao gas là cần thiết?
Ethereum giống như một chiếc máy tính lớn, chậm nhưng cực kỳ an toàn. Khi bạn thực thi một hàm, t
ất cả các nút (nodes) trên mạng đều phải chạy cùng một hàm để xác minh kết quả — hàng ngàn nút xác minh từng lần thực thi hàm chính là lý do khiến Ethereum phân tán (decentralized), dữ liệu của nó không thể thay đổi và chống lại kiểm duyệt.

Những người tạo ra Ethereum muốn đảm bảo rằng không ai có thể làm tắc nghẽn mạng bằng một vòng lặp vô hạn hoặc chiếm hết tài nguyên mạng với các phép tính quá phức tạp.
Vì vậy, họ đã tạo ra hệ thống giao dịch có tính phí và người dùng phải trả tiền cho thời gian tính toán cũng như lưu trữ.

Lưu ý: Điều này không nhất thiết đúng với các blockchain khác, như những blockchain mà các tác giả của CryptoZombies đang xây dựng trên Loom Network.
Có lẽ sẽ không bao giờ hợp lý khi chạy một trò chơi như World of Warcraft trực tiếp trên Ethereum mainnet — chi phí gas sẽ quá cao. Nhưng trò chơi có thể chạy trên một blockchain có thuật toán đồng thuận khác
Chúng ta sẽ thảo luận thêm về loại DApp bạn nên triển khai trên Loom và loại nào nên triển khai trên Ethereum mainnet trong một bài học sau.

Gói struct để tiết kiệm gas
Trong Bài học 1, chúng ta đã đề cập rằng có các loại uint khác như: uint8, uint16, uint32, v.v.

Thông thường, không có lợi ích khi sử dụng các kiểu này vì Solidity dành 256 bit bộ nhớ bất kể kích thước của uint. Ví dụ, sử dụng uint8 thay vì uint (uint256) sẽ không tiết kiệm được gas.

Tuy nhiên, có một ngoại lệ: bên trong các struct.

Nếu bạn có nhiều uint trong một struct, sử dụng các uint kích thước nhỏ hơn sẽ cho phép Solidity gói các biến này lại với nhau để chiếm ít bộ nhớ hơn. Ví dụ:

solidity
struct NormalStruct {
  uint a;
  uint b;
  uint c;
}

struct MiniMe {
  uint32 a;
  uint32 b;
  uint c;
}

// `mini` sẽ tốn ít gas hơn `normal` vì có gói struct
NormalStruct normal = NormalStruct(10, 20, 30);
MiniMe mini = MiniMe(10, 20, 30);
Vì lý do này, bên trong một struct, bạn sẽ muốn sử dụng các loại số nguyên nhỏ nhất mà có thể.

Bạn cũng nên sắp xếp các kiểu dữ liệu giống nhau (tức là đặt chúng cạnh nhau trong struct) để Solidity có thể tối ưu hóa không gian lưu trữ cần thiết. 
Ví dụ, một struct có các trường uint c; uint32 a; uint32 b; sẽ tốn ít gas hơn một struct với các trường uint32 a; uint c; uint32 b; vì các trường uint32 được nhóm lại với nhau.

*/
pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

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
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
