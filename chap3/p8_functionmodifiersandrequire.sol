/
Chương 8: Tìm hiểu thêm về Function Modifiers

Tuyệt vời! Zombie của chúng ta hiện đã có một bộ đếm thời gian chờ hoạt động.

Tiếp theo, chúng ta sẽ thêm một số phương thức trợ giúp bổ sung. Chúng tôi đã tạo một tệp mới cho bạn có tên là zombiehelper.sol, 
  trong đó nhập zombiefeeding.sol. Điều này sẽ giúp mã của chúng ta được tổ chức rõ ràng hơn.

Chúng ta sẽ làm cho zombie có thể nhận được các kỹ năng đặc biệt sau khi đạt đến một cấp độ nhất định. Nhưng để làm được điều đó, trước tiên chúng ta cần tìm hiểu thêm một chút về function modifiers.

Function modifiers có tham số
Trước đó chúng ta đã xem qua ví dụ đơn giản của onlyOwner. Nhưng function modifiers cũng có thể nhận các tham số. Ví dụ:

solidity
// Một mapping để lưu trữ tuổi của người dùng:
mapping (uint => uint) public age;

// Modifier yêu cầu người dùng này phải lớn hơn một độ tuổi nhất định:
modifier olderThan(uint _age, uint _userId) {
  require(age[_userId] >= _age);
  _;
}

// Phải lớn hơn 16 tuổi để lái xe (ít nhất là ở Mỹ).
// Chúng ta có thể gọi modifier `olderThan` với các tham số như sau:
function driveCar(uint _userId) public olderThan(16, _userId) {
  // Một số logic của hàm
}
Bạn có thể thấy rằng modifier olderThan nhận tham số giống như một hàm. Và hàm driveCar truyền tham số của nó cho modifier.

Hãy thử tạo modifier của riêng chúng ta sử dụng thuộc tính cấp độ zombie để giới hạn quyền truy cập vào các kỹ năng đặc biệt.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  // Start here
  modifier aboveLevel(uint _level, uint _zombieId)
  {
    require(zombies[_zombieId].level >= _level);
    _;
  }
}
