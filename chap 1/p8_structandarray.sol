/*
Trong Solidity, chúng ta có thể sử dụng các structs và mảng (arrays) để tổ chức dữ liệu phức tạp. Cùng tìm hiểu cách tạo và thao tác với structs và arrays qua ví dụ về struct Person và mảng people.

Khai báo Struct và Mảng:

struct Person {
    uint age;
    string name;
}

Person[] public people;
Ở đây:

Struct Person có hai trường: age (tuổi) là số nguyên không dấu (uint), và name (tên) là một chuỗi (string).
Mảng people chứa các đối tượng kiểu Person, được khai báo công khai để bất kỳ ai cũng có thể truy cập.
Tạo đối tượng Struct mới:
Để tạo một đối tượng mới của Person, ta có thể làm như sau:

// Tạo một đối tượng Person mới:
Person satoshi = Person(172, "Satoshi");
Ở đây, đối tượng satoshi được tạo với tuổi là 172 và tên là "Satoshi".

Thêm vào mảng:
Để thêm đối tượng satoshi vào mảng people, ta sử dụng phương thức push():

// Thêm người vào mảng:
people.push(satoshi);
Kết hợp trong một dòng:
Bạn cũng có thể kết hợp việc tạo và thêm đối tượng vào mảng trong cùng một dòng để mã ngắn gọn hơn:

// Tạo và thêm một Person vào mảng chỉ với một dòng:
people.push(Person(16, "Vitalik"));
Thao tác với mảng số nguyên:
Ví dụ dưới đây cho thấy cách thêm các phần tử vào một mảng số nguyên:

solidity
uint[] numbers;
numbers.push(5);
numbers.push(10);
numbers.push(15);
Sau khi chạy đoạn mã trên, mảng numbers sẽ chứa các giá trị [5, 10, 15]. Lưu ý rằng phương thức array.push() sẽ luôn thêm phần tử mới vào cuối mảng.

Tóm lại, chúng ta có thể dễ dàng tạo các đối tượng struct, thêm chúng vào mảng, và quản lý dữ liệu một cách có tổ chức trong Solidity.
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

    function createZombie (string memory _name, uint _dna) public {
        // start here
        zombies.push(Zombie(_name, _dna));
    }

}
