/*
Trong Solidity, khi dự án của bạn bắt đầu trở nên phức tạp và dài, việc chia nhỏ code thành nhiều file là một cách tổ chức rất phổ biến. Điều này giúp mã của bạn dễ quản lý hơn, dễ đọc hơn, và tái sử dụng được giữa các phần khác nhau của dự án.

Từ khóa import
Trong Solidity, bạn có thể sử dụng từ khóa import để lấy mã từ một file khác và sử dụng nó trong file hiện tại. Cách sử dụng rất đơn giản, cú pháp như sau:

solidity
import "./someothercontract.sol";
Ở đây, ./someothercontract.sol là đường dẫn đến file bạn muốn import, nơi ./ có nghĩa là file someothercontract.sol nằm trong cùng thư mục với file hiện tại.

Sử dụng với inheritance (Kế thừa)
Một trong những lý do phổ biến để import các file khác là bạn muốn kế thừa (inherit) một contract từ file khác vào contract hiện tại của bạn. Ví dụ:

solidity
import "./someothercontract.sol";

contract newContract is SomeOtherContract {

}
Trong ví dụ này:

someothercontract.sol là file chứa SomeOtherContract.
Contract newContract kế thừa từ SomeOtherContract, tức là nó có thể truy cập và sử dụng tất cả các hàm, biến, và logic được định nghĩa trong SomeOtherContract.
Lợi ích của việc chia nhỏ code và sử dụng import
Tái sử dụng mã: Bạn có thể chia sẻ và sử dụng lại mã trong nhiều phần khác nhau của dự án mà không cần phải viết lại.
Quản lý dễ dàng hơn: Mỗi file có thể quản lý một phần cụ thể của logic, giúp dự án của bạn gọn gàng và dễ kiểm soát hơn.
Tăng cường bảo mật: Mỗi file có thể được kiểm tra, phân tích, và bảo trì độc lập, giúp giảm thiểu lỗi và tăng cường tính bảo mật của dự án.
Trong các dự án Solidity lớn, đặc biệt khi bạn làm việc với nhiều hợp đồng thông minh (smart contracts), việc chia nhỏ code và sử dụng import sẽ giúp bạn giữ cho dự án của mình rõ ràng và dễ quản lý hơn.
*/
pragma solidity >=0.5.0 <0.6.0;
 
import "./zombiefactory.sol";
contract ZombieFeeding is ZombieFactory {

}
