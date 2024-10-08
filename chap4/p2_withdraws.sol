 /*
 Chương 2: Rút tiền
Trong chương trước, chúng ta đã học cách gửi Ether vào một hợp đồng. Vậy điều gì xảy ra sau khi bạn gửi nó?

Sau khi bạn gửi Ether vào một hợp đồng, nó sẽ được lưu trữ trong tài khoản Ethereum của hợp đồng và sẽ bị kẹt ở đó — trừ khi bạn thêm một hàm để rút Ether ra khỏi hợp đồng.

Bạn có thể viết một hàm để rút Ether ra khỏi hợp đồng như sau:

solidity
contract GetPaid is Ownable {
  function withdraw() external onlyOwner {
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }
}
Lưu ý rằng chúng ta đang sử dụng owner() và onlyOwner từ hợp đồng Ownable, giả sử rằng hợp đồng đó đã được nhập khẩu.

Điều quan trọng cần lưu ý là bạn không thể chuyển Ether đến một địa chỉ trừ khi địa chỉ đó có kiểu dữ liệu address payable. Nhưng biến _owner có kiểu dữ liệu uint160, nghĩa là chúng ta phải ép kiểu nó thành address payable.

Khi bạn đã ép kiểu địa chỉ từ uint160 sang address payable, bạn có thể chuyển Ether đến địa chỉ đó bằng cách sử dụng hàm transfer, và address(this).balance sẽ trả về số dư tổng cộng được lưu trữ trên hợp đồng. 
Vì vậy, nếu 100 người dùng đã trả 1 Ether cho hợp đồng của chúng ta, thì address(this).balance sẽ bằng 100 Ether.

Bạn có thể sử dụng hàm transfer để gửi tiền đến bất kỳ địa chỉ Ethereum nào. Ví dụ, bạn có thể có một hàm chuyển Ether lại cho msg.sender nếu họ trả quá nhiều cho một mặt hàng:

solidity
uint itemFee = 0.001 ether;
msg.sender.transfer(msg.value - itemFee);
Hoặc trong một hợp đồng với người mua và người bán, bạn có thể lưu trữ địa chỉ của người bán, sau đó khi ai đó mua mặt hàng của anh ta, bạn có thể chuyển khoản thanh toán từ người mua đến người bán: seller.transfer(msg.value).

Đây là một số ví dụ về điều làm cho lập trình trên Ethereum trở nên thú vị — bạn có thể có các chợ phi tập trung như thế này mà không ai kiểm soát.
 */
 pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  // 1. Create withdraw function here
  function withdraw() external onlyOwner
  {
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }
  // 2. Create setLevelUpFee function here
  function setLevelUpFee(uint _fee) external onlyOwner
  {
    levelUpFee = _fee;
  }
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
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
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
