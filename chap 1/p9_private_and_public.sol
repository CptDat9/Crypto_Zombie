/*
Trong Solidity, các hàm mặc định là public (công khai), có nghĩa là bất kỳ ai (hoặc hợp đồng nào khác) cũng có thể gọi và thực thi mã của hàm đó. Điều này có thể gây ra rủi ro bảo mật nếu không cẩn thận, vì vậy, một phương pháp hay là nên đặt các hàm private (riêng tư) mặc định và chỉ công khai những hàm bạn muốn cho phép truy cập từ bên ngoài.

Khai báo hàm private
Dưới đây là ví dụ về cách khai báo một hàm private:

solidity
Sao chép mã
uint[] numbers;

function _addToArray(uint _number) private {
    numbers.push(_number);
}
Giải thích:
Từ khóa private:

Hàm _addToArray được đánh dấu là private, có nghĩa là chỉ có các hàm khác trong cùng một hợp đồng mới có thể gọi nó.
Các hàm hoặc hợp đồng bên ngoài không thể gọi hàm này.
Quy ước sử dụng dấu gạch dưới (_):

Theo quy ước, các hàm private thường được bắt đầu bằng dấu gạch dưới (_) để dễ phân biệt với các hàm public hoặc hàm từ bên ngoài.
Điều này không bắt buộc, nhưng giúp mã dễ đọc và hiểu hơn.
Ví dụ về việc sử dụng hàm private:
Giả sử bạn có một hàm public muốn sử dụng hàm private này:

solidity
Sao chép mã
function addNumber(uint _number) public {
    _addToArray(_number);
}
Trong ví dụ này, hàm public addNumber có thể gọi hàm private _addToArray để thêm số vào mảng numbers. Nhưng từ bên ngoài, người dùng hoặc các hợp đồng khác không thể trực tiếp gọi _addToArray.

Tóm lại:
Hàm public là công khai, ai cũng có thể gọi.
Hàm private chỉ có thể được gọi từ bên trong hợp đồng.
Sử dụng từ khóa private và quy ước dấu gạch dưới giúp tăng tính bảo mật và rõ ràng khi viết hợp đồng Solidity.
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

}




