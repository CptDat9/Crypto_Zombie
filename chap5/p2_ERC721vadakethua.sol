Chương 2: Tiêu chuẩn ERC721, Kế thừa đa hợp

Hãy cùng xem tiêu chuẩn ERC721:

solidity
contract ERC721 {
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

  function balanceOf(address _owner) external view returns (uint256);
  function ownerOf(uint256 _tokenId) external view returns (address);
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
  function approve(address _approved, uint256 _tokenId) external payable;
}
Đây là danh sách các phương thức mà chúng ta cần triển khai, và chúng ta sẽ làm từng phần qua các chương tiếp theo.

Nhìn có vẻ nhiều, nhưng đừng quá lo lắng! Chúng tôi sẽ hướng dẫn bạn từng bước.

Triển khai một hợp đồng token
Khi triển khai một hợp đồng token, việc đầu tiên chúng ta làm là sao chép giao diện này vào một tệp Solidity riêng và nhập nó bằng cách sử dụng import "./erc721.sol";. Sau đó, chúng ta sẽ để hợp đồng của mình kế thừa từ nó, và ghi đè từng phương thức với một định nghĩa hàm.

Nhưng khoan đã — ZombieOwnership đã kế thừa từ ZombieAttack rồi — làm thế nào nó có thể kế thừa thêm từ ERC721?

May mắn thay, trong Solidity, hợp đồng của bạn có thể kế thừa từ nhiều hợp đồng như sau:

solidity
contract SatoshiNakamoto is NickSzabo, HalFinney {
  // Ôi trời, bí mật của vũ trụ đã được tiết lộ!
}
Như bạn có thể thấy, khi sử dụng kế thừa đa hợp, bạn chỉ cần phân tách các hợp đồng bạn đang kế thừa bằng dấu phẩy ,. Trong trường hợp này, hợp đồng của chúng ta đang kế thừa từ NickSzabo và HalFinney.

Hãy thử nào!
----------------------------------------------------------------------
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
// Import file here
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 
//Đa kế thừa dùng thêm dấu "," thôi. {

}
