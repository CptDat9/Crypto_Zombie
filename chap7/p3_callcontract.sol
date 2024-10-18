/*
Chương 3: Gọi Các Hợp Đồng Khác - Tiếp theo

Tuyệt vời! Bây giờ bạn đã lưu địa chỉ của oracle vào một biến, hãy cùng học cách gọi hàm từ một hợp đồng khác.

Gọi Hợp Đồng Oracle
Để hợp đồng thông minh gọi có thể tương tác với hợp đồng oracle, bạn cần phải định nghĩa một cái gọi là giao diện (interface).

Interface có phần tương tự như hợp đồng, nhưng chúng chỉ khai báo các hàm. Nói cách khác, một interface không thể:

Định nghĩa các biến trạng thái,
Định nghĩa constructors,
Hoặc kế thừa từ các hợp đồng khác.
Bạn có thể coi interface giống như ABI (Application Binary Interface). Vì chúng được sử dụng để cho phép các hợp đồng khác nhau tương tác với nhau, tất cả các hàm trong interface đều phải là external.

Hãy xem một ví dụ đơn giản. Giả sử có một hợp đồng gọi là FastFood với mã nguồn như sau:

solidity
pragma solidity 0.5.0;

contract FastFood {
  function makeSandwich(string calldata _fillingA, string calldata _fillingB) external {
    // Làm sandwich
  }
}
Hợp đồng đơn giản này triển khai một hàm có tên là makeSandwich để "làm" sandwich. Nếu bạn biết địa chỉ của hợp đồng FastFood và chữ ký của hàm makeSandwich, bạn có thể gọi nó.

Lưu ý: Một chữ ký hàm bao gồm tên hàm, danh sách các tham số và giá trị trả về (nếu có).

Tiếp tục với ví dụ trên, giả sử bạn muốn viết một hợp đồng có tên là PrepareLunch để gọi hàm makeSandwich, truyền vào danh sách nguyên liệu như "thịt nguội thái lát" và "rau dưa muối". Mặc dù tôi không đói, nhưng nghe có vẻ hấp dẫn 😄.

Để hợp đồng PrepareLunch có thể gọi hàm makeSandwich, bạn phải thực hiện các bước sau:

Định nghĩa giao diện của hợp đồng FastFood bằng cách dán đoạn mã sau vào một tệp có tên FastFoodInterface.sol:
solidity
pragma solidity 0.5.0;

interface FastFoodInterface {
   function makeSandwich(string calldata _fillingA, string calldata _fillingB) external;
}
Nhập nội dung của tệp ./FastFoodInterface.sol vào hợp đồng PrepareLunch.

Khởi tạo hợp đồng FastFood bằng cách sử dụng interface:

solidity
fastFoodInstance = FastFoodInterface(_address);
Lúc này, hợp đồng PrepareLunch có thể gọi hàm makeSandwich từ hợp đồng FastFood như sau:

solidity
fastFoodInstance.makeSandwich("sliced ham", "pickled veggies");
Tổng hợp lại, đây là cách mà hợp đồng PrepareLunch sẽ trông như thế này:

solidity
pragma solidity 0.5.0;
import "./FastFoodInterface.sol";

contract PrepareLunch {

  FastFoodInterface private fastFoodInstance;

  function instantiateFastFoodContract (address _address) public {
    fastFoodInstance = FastFoodInterface(_address);
    fastFoodInstance.makeSandwich("sliced ham", "pickled veggies");
  }
}
Bây giờ, hãy sử dụng ví dụ trên làm cảm hứng để bạn thiết lập hợp đồng gọi thực hiện hàm updateEthPrice từ hợp đồng oracle.
*/
pragma solidity 0.5.0;
//1. Import from the "./EthPriceOracleInterface.sol" file
import "./EthPriceOracleInterface.sol";
contract CallerContract {
  // 2. Declare `EthPriceOracleInterface`
  EthPriceOracleInterface private oracleInstance;
  address private oracleAddress;
  function setOracleInstanceAddress (address _oracleInstanceAddress) public {
    oracleAddress = _oracleInstanceAddress;
    //3. Instantiate `EthPriceOracleInterface`
    oracleInstance = EthPriceOracleInterface(oracleAddress);
  }
}
