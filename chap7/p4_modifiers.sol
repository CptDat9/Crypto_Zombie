/*
Chương 4: Các Modifiers Hàm

Bạn đã nhận ra vấn đề bảo mật trong chương trước chưa?

Nếu chưa, để tôi giúp bạn với câu trả lời: khi bạn viết một hàm public, bất kỳ ai cũng có thể thực thi nó... và thay đổi địa chỉ của oracle thành bất kỳ giá trị nào mà họ muốn.

Vậy làm thế nào để khắc phục vấn đề này?

Modifier onlyOwner
Giải pháp là bạn phải sử dụng một cái gọi là modifier. Modifier là một đoạn mã thay đổi hành vi của một hàm. Ví dụ, bạn có thể kiểm tra rằng một điều kiện cụ thể được thỏa mãn trước khi thực thi hàm thực tế.

Vì vậy, để khắc phục lỗ hổng bảo mật này, bạn cần thực hiện các bước sau:

Nhập nội dung của hợp đồng thông minh Ownable từ OpenZeppelin. Chúng ta đã làm quen với OpenZeppelin trong các bài học trước, nếu cần, bạn có thể quay lại và ôn lại kiến thức.
Kế thừa hợp đồng từ Ownable.
Thay đổi định nghĩa của hàm setOracleInstanceAddress để sử dụng modifier onlyOwner.
Dưới đây là ví dụ về cách sử dụng một modifier:

solidity
contract MyContract {
  function doSomething() public onlyMe {
    // làm gì đó
  }
}
Trong ví dụ này, modifier onlyMe được thực thi trước, trước khi mã bên trong hàm doSomething được thực hiện.

Thật dễ dàng đúng không? Bây giờ, đến lượt bạn thực hành điều này😉.
*/
pragma solidity 0.5.0;
import "./EthPriceOracleInterface.sol";
// 1. import the contents of "openzeppelin-solidity/contracts/ownership/Ownable.sol"
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
contract CallerContract is Ownable { // 2. Make the contract inherit from `Ownable`
    EthPriceOracleInterface private oracleInstance;
    address private oracleAddress;
    event newOracleAddressEvent(address oracleAddress);
    // 3. On the next line, add the `onlyOwner` modifier to the `setOracleInstanceAddress` function definition
    function setOracleInstanceAddress (address _oracleInstanceAddress) public onlyOwner {
      oracleAddress = _oracleInstanceAddress;
      oracleInstance = EthPriceOracleInterface(oracleAddress);
      // 4. Fire `newOracleAddressEvent`
      emit newOracleAddressEvent(oracleAddress);
    }
}







