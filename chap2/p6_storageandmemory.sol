/*Chương 7: Storage vs Memory (Vị trí lưu trữ dữ liệu)

Trong Solidity, có hai vị trí bạn có thể lưu trữ biến — trong storage và memory.

Storage dùng để chỉ các biến được lưu trữ vĩnh viễn trên blockchain. Các biến memory là tạm thời và sẽ bị xóa sau mỗi lần gọi hàm bên ngoài contract của bạn. Hãy nghĩ về nó giống như ổ cứng so với RAM trên máy tính của bạn.

Phần lớn thời gian, bạn không cần sử dụng các từ khóa này vì Solidity xử lý chúng tự động. Các biến trạng thái (biến được khai báo bên ngoài hàm) mặc định là storage và được ghi vĩnh viễn vào blockchain, trong khi các biến được khai báo bên trong hàm là memory và
sẽ biến mất khi kết thúc cuộc gọi hàm.

Tuy nhiên, có những trường hợp bạn cần sử dụng các từ khóa này, đặc biệt là khi làm việc với struct và array bên trong hàm:

solidity
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    // Sandwich mySandwich = sandwiches[_index];

    // ^ Có vẻ khá đơn giản, nhưng solidity sẽ cảnh báo bạn
    // rằng bạn nên khai báo rõ ràng `storage` hoặc `memory` ở đây.

    // Vì vậy, thay vào đó, bạn nên khai báo với từ khóa `storage`, như sau:
    Sandwich storage mySandwich = sandwiches[_index];
    // ...trong trường hợp này `mySandwich` là con trỏ tới `sandwiches[_index]`
    // trong storage, và...
    mySandwich.status = "Eaten!";
    // ...điều này sẽ thay đổi vĩnh viễn `sandwiches[_index]` trên blockchain.

    // Nếu bạn chỉ muốn một bản sao, bạn có thể sử dụng `memory`:
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...trong trường hợp này `anotherSandwich` sẽ chỉ là bản sao của
    // dữ liệu trong bộ nhớ, và...
    anotherSandwich.status = "Eaten!";
    // ...chỉ thay đổi biến tạm thời và không ảnh hưởng đến
    // `sandwiches[_index + 1]`. Nhưng bạn có thể làm điều này:
    sandwiches[_index + 1] = anotherSandwich;
    
    // ...nếu bạn muốn sao chép các thay đổi trở lại storage trên blockchain.
  }
}
Đừng lo lắng nếu bạn chưa hiểu hoàn toàn khi nào sử dụng cái nào — trong suốt hướng dẫn này, chúng tôi sẽ chỉ cho bạn khi nào nên sử dụng storage và khi nào 
nên dùng memory, và trình biên dịch Solidity cũng sẽ cảnh báo cho bạn khi bạn cần sử dụng một trong các từ khóa này.

Hiện tại, bạn chỉ cần hiểu rằng có những trường hợp bạn sẽ cần khai báo rõ ràng storage hoặc memory!
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

    function feedAndMultiply(uint _zombieId, uint _targetDna) public
{
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
}
}
