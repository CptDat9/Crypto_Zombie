


/*
Để làm điều này, chúng ta cần đọc kittyDna từ hợp đồng thông minh CryptoKitties. Chúng ta có thể làm điều đó vì dữ liệu CryptoKitties được lưu trữ công khai trên blockchain. Blockchain thật tuyệt phải không?!

Tương tác với các hợp đồng khác Để hợp đồng của chúng ta có thể giao tiếp với một hợp đồng khác trên blockchain mà chúng ta không sở hữu, trước tiên chúng ta cần định nghĩa một giao diện.

Hãy xem một ví dụ đơn giản. Giả sử có một hợp đồng trên blockchain trông như thế này:

solidity
contract LuckyNumber {
  mapping(address => uint) numbers;

  function setNum(uint _num) public {
    numbers[msg.sender] = _num;
  }

  function getNum(address _myAddress) public view returns (uint) {
    return numbers[_myAddress];
  }
}
Đây sẽ là một hợp đồng đơn giản mà bất kỳ ai cũng có thể lưu trữ số may mắn của mình, và nó sẽ được liên kết với địa chỉ Ethereum của họ. Sau đó, bất kỳ ai khác cũng có thể tra cứu số may mắn của người đó bằng cách sử dụng địa chỉ của họ.

Bây giờ hãy giả sử chúng ta có một hợp đồng bên ngoài muốn đọc dữ liệu trong hợp đồng này bằng cách sử dụng hàm getNum.

Đầu tiên, chúng ta phải định nghĩa một giao diện cho hợp đồng LuckyNumber:

solidity
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
Lưu ý rằng điều này trông giống như việc định nghĩa một hợp đồng, với một vài điểm khác biệt. Thứ nhất, chúng ta chỉ khai báo các hàm mà chúng ta muốn tương tác — trong trường hợp này là getNum — và chúng ta không đề cập đến bất kỳ hàm hoặc biến trạng thái nào khác.

Thứ hai, chúng ta không định nghĩa thân hàm. Thay vì sử dụng dấu ngoặc nhọn ({ và }), chúng ta chỉ đơn giản kết thúc khai báo hàm bằng dấu chấm phẩy (;).

Vì vậy, nó trông giống như một bộ khung của hợp đồng. Đây là cách mà trình biên dịch biết rằng đó là một giao diện.

Bằng cách bao gồm giao diện này trong mã của dapp, hợp đồng của chúng ta biết các hàm của hợp đồng khác trông như thế nào, cách gọi chúng và loại phản hồi nào để mong đợi.

Chúng ta sẽ tìm hiểu cách gọi các hàm của hợp đồng khác trong bài học tiếp theo, nhưng trước tiên hãy khai báo giao diện của chúng ta cho hợp đồng CryptoKitties.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// Create KittyInterface here
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
); 

}

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    _createZombie("NoName", newDna);
  }

}
