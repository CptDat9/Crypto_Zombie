/* 
Trong Solidity, mảng (arrays) là một cấu trúc dữ liệu hữu ích để lưu trữ nhiều phần tử của cùng một kiểu. Có hai loại mảng trong Solidity: mảng cố định (fixed arrays) và mảng động (dynamic arrays).

Mảng cố định và mảng động
Mảng cố định có một kích thước xác định trước. Một khi đã khai báo, kích thước này không thể thay đổi.

solidity
uint[2] fixedArray; // Mảng cố định chứa 2 số nguyên
string[5] stringArray; // Mảng cố định chứa 5 chuỗi
Mảng động không có kích thước cố định, có thể thêm các phần tử mới một cách linh hoạt.

solidity
uint[] dynamicArray; // Mảng động có thể tăng kích thước tùy ý
Ngoài ra, bạn có thể tạo một mảng chứa các struct. Ví dụ, từ struct Person đã học ở chương trước:

solidity
Person[] people; // Mảng động chứa các struct Person
Mảng này lưu trữ nhiều đối tượng Person, và bạn có thể thêm các phần tử vào nó theo nhu cầu. Điều này đặc biệt hữu ích khi cần lưu trữ dữ liệu cấu trúc trên blockchain.

Mảng công khai (Public Arrays)
Bạn có thể khai báo một mảng là public. Solidity sẽ tự động tạo ra một getter method (phương thức truy cập) cho mảng đó:

solidity
Person[] public people;
Với khai báo này:

Các hợp đồng khác có thể đọc dữ liệu từ mảng people, nhưng không thể ghi dữ liệu vào mảng.
Điều này rất hữu ích khi bạn muốn lưu trữ dữ liệu công khai và cho phép các ứng dụng khác truy cập dữ liệu mà không cho phép họ thay đổi nội dung.
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
    

}
