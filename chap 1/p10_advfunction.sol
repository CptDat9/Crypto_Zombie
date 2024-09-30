/*
Chương 10: Nhiều hơn về Hàm

Trong chương này, chúng ta sẽ tìm hiểu thêm về giá trị trả về của hàm và bộ sửa đổi hàm trong Solidity.
Giá trị trả về
Để trả về một giá trị từ hàm, chúng ta cần khai báo kiểu dữ liệu của giá trị trả về. Ví dụ:

solidity
string greeting = "What's up dog";
function sayHello() public returns (string memory) {
    return greeting;
}
Trong ví dụ trên, kiểu trả về được khai báo là string memory, có nghĩa là hàm sẽ trả về một chuỗi ký tự được lưu trữ trong bộ nhớ.

Bộ sửa đổi hàm (Function Modifiers)
Có thể thêm các bộ sửa đổi như view và pure vào hàm tùy theo chức năng của chúng.

view: Sử dụng khi hàm chỉ xem dữ liệu mà không thay đổi trạng thái.
solidity
function sayHello() public view returns (string memory) {
    return greeting;
}
pure: Sử dụng khi hàm không truy cập vào dữ liệu của ứng dụng, chỉ dựa trên các tham số đầu vào.
solidity
function _multiply(uint a, uint b) private pure returns (uint) {
    return a * b;
}
Hàm pure không đọc hay thay đổi trạng thái của ứng dụng, chỉ thực hiện phép tính dựa trên tham số truyền vào.
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

    function _generateRandomDna(string memory _str) private view returns (uint)
    {

    }

}
