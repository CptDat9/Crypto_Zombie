/*
Chương 11: Lưu trữ là tốn kém

Một trong những thao tác tốn kém nhất trong Solidity là sử dụng lưu trữ — đặc biệt là khi ghi dữ liệu.

Điều này là do mỗi khi bạn ghi hoặc thay đổi một dữ liệu, nó được ghi vĩnh viễn vào blockchain. 
Mãi mãi! Hàng ngàn node trên khắp thế giới cần lưu trữ dữ liệu đó trên ổ cứng của họ, và lượng dữ liệu này ngày càng tăng lên khi blockchain phát triển. Vì vậy, việc ghi dữ liệu đi kèm với một chi phí.

Để giữ chi phí thấp, bạn nên tránh ghi dữ liệu vào lưu trữ trừ khi thực sự cần thiết.
Đôi khi điều này đòi hỏi logic lập trình dường như không hiệu quả — như việc xây dựng lại một mảng trong bộ nhớ mỗi khi một hàm được gọi thay vì chỉ đơn giản lưu mảng đó vào một biến để tra cứu nhanh.

Trong hầu hết các ngôn ngữ lập trình, việc lặp qua các tập dữ liệu lớn là tốn kém. Nhưng trong Solidity, 
điều này rẻ hơn rất nhiều so với việc sử dụng lưu trữ nếu nó nằm trong một hàm dạng view gọi từ bên ngoài, vì các hàm view không tốn gas của người dùng (và gas là tiền thật!).

Chúng ta sẽ thảo luận về vòng lặp for trong chương tiếp theo, nhưng trước hết, hãy cùng xem cách khai báo các mảng trong bộ nhớ.

Khai báo mảng trong bộ nhớ
Bạn có thể sử dụng từ khóa memory với các mảng để tạo một mảng mới bên trong một hàm mà không cần ghi gì vào lưu trữ.
Mảng này sẽ chỉ tồn tại cho đến khi kết thúc hàm, và cách này tiết kiệm gas hơn rất nhiều so với việc cập nhật một mảng trong lưu trữ — hoàn toàn miễn phí nếu đó là một hàm view được gọi từ bên ngoài.

Dưới đây là cách khai báo một mảng trong bộ nhớ:

solidity
function getArray() external pure returns(uint[] memory) {
  // Khởi tạo một mảng mới trong bộ nhớ với độ dài là 3
  uint;

  // Gán một số giá trị cho nó
  values[0] = 1;
  values[1] = 2;
  values[2] = 3;

  return values;
}
Đây là một ví dụ đơn giản chỉ để minh họa cú pháp, nhưng trong chương tiếp theo, chúng ta sẽ kết hợp điều này với vòng lặp for cho các trường hợp sử dụng thực tế.

Lưu ý: các mảng memory phải được tạo với một đối số độ dài (trong ví dụ này là 3). Hiện tại, chúng không thể thay đổi kích thước như các mảng trong lưu trữ có thể làm với array.push(),
mặc dù điều này có thể sẽ thay đổi trong phiên bản tương lai của Solidity.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    // Start here
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    return result;

  }

}
