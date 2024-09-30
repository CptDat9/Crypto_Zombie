/*
Chương 11: Keccak256 và Ép kiểu (Typecasting)

Keccak256
Hàm keccak256 là một hàm băm được tích hợp trong Ethereum, tương tự như SHA3. Nó chuyển đổi đầu vào thành một chuỗi 256-bit thập lục phân ngẫu nhiên. Chỉ một thay đổi nhỏ trong đầu vào cũng có thể tạo ra sự khác biệt lớn trong kết quả băm.

Ví dụ:
solidity
keccak256(abi.encodePacked("aaaab")); // 6e91ec...
keccak256(abi.encodePacked("aaaac")); // b1f078...
Kết quả thay đổi hoàn toàn dù chỉ có một ký tự khác nhau.

Lưu ý: Trong blockchain, việc tạo số ngẫu nhiên an toàn là rất khó. Mặc dù phương pháp này không an toàn, nhưng đủ để sử dụng cho việc tạo DNA của zombie.

Ép kiểu (Typecasting)
Khi cần chuyển đổi giữa các kiểu dữ liệu, chúng ta sử dụng ép kiểu. Ví dụ:

solidity
uint8 a = 5;
uint b = 6;
// Lỗi vì kết quả trả về là uint, không phải uint8:
uint8 c = a * b;
// Giải quyết bằng cách ép kiểu b thành uint8:
uint8 c = a * uint8(b);
Việc ép kiểu giúp tránh các lỗi khi làm việc với các kiểu dữ liệu khác nhau trong Solidity.
*/
pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        // start here
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand%dnaModulus;
    }

}
