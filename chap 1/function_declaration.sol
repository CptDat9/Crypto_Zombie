/*
Trong Solidity, một khai báo hàm có dạng như sau:

Code:
function eatHamburgers(string memory _name, uint _amount) public {
    // Thân hàm rỗng
}
Đây là một hàm có tên là eatHamburgers, nhận hai tham số:

_name: kiểu string, được lưu trữ trong bộ nhớ (memory). Điều này là bắt buộc cho các kiểu tham chiếu như chuỗi (strings), mảng (arrays), structs, và mappings.
_amount: kiểu số nguyên không dấu (uint).
Chúng ta cũng quy định phạm vi truy cập của hàm là public, có nghĩa là bất kỳ ai cũng có thể gọi hàm này từ bên ngoài hợp đồng.

Kiểu tham chiếu là gì?
Khi truyền tham số cho một hàm trong Solidity, có hai cách:

Truyền theo giá trị (by value): Solidity tạo một bản sao mới của giá trị tham số và truyền nó vào hàm. Điều này đảm bảo rằng hàm có thể thay đổi giá trị mà không ảnh hưởng đến biến gốc.

Truyền theo tham chiếu (by reference): Hàm nhận một tham chiếu trực tiếp đến biến gốc. Nếu hàm thay đổi giá trị của biến đó, biến gốc cũng bị thay đổi.

Lưu ý:
Theo quy ước, người ta thường thêm dấu gạch dưới (_) trước tên biến trong tham số để phân biệt với các biến toàn cục. Tuy nhiên, điều này không bắt buộc.

Gọi hàm:
Bạn có thể gọi hàm eatHamburgers như sau:

solidity
Sao chép mã
eatHamburgers("vitalik", 100);
Trong ví dụ này, chuỗi "vitalik" được truyền vào tham số _name, và số 100 vào tham số _amount.
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

    // start here
    function createZombie(string memory _name, uint _dna) public
    {

    }

}
