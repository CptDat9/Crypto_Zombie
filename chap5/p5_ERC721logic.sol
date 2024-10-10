
Chương 5: ERC721 - Logic Chuyển Quyền Sở Hữu
Tuyệt vời, chúng ta đã giải quyết xung đột!

Bây giờ chúng ta sẽ tiếp tục triển khai ERC721 bằng cách tìm hiểu việc chuyển quyền sở hữu từ một người sang người khác.

Lưu ý rằng tiêu chuẩn ERC721 có 2 cách khác nhau để chuyển token:

solidity
function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
và

solidity
function approve(address _approved, uint256 _tokenId) external payable;
Cách 1: transferFrom
Cách đầu tiên là chủ sở hữu token gọi hàm transferFrom với địa chỉ của mình là tham số _from, địa chỉ mà họ muốn chuyển đến là tham số _to, và _tokenId của token họ muốn chuyển.

Cách 2: approve và sau đó transferFrom
Cách thứ hai là chủ sở hữu token trước tiên gọi hàm approve với địa chỉ mà họ muốn chuyển đến và _tokenId. Hợp đồng sẽ lưu trữ ai được phép nhận token này,thường trong một phép ánh xạ (mapping) như (uint256 => address). 
Sau đó, khi chủ sở hữu hoặc địa chỉ đã được phê duyệt gọi transferFrom, hợp đồng sẽ kiểm tra xem msg.sender có phải là chủ sở hữu hoặc người được phê duyệt để nhận token hay không, và nếu đúng thì hợp đồng sẽ chuyển token cho họ.

Tóm tắt:
Lưu ý rằng cả hai phương thức đều chứa cùng một logic chuyển quyền sở hữu. Trong một trường hợp, người gửi token sẽ gọi hàm transferFrom; trong trường hợp khác, chủ sở hữu hoặc người nhận đã được phê duyệt sẽ gọi nó.

Do đó, chúng ta nên trừu tượng hóa logic này thành một hàm riêng tư, chẳng hạn như _transfer, và sau đó để hàm transferFrom gọi hàm này.
------------------------------------------------------------------------
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  // Define _transfer() here
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId]=_to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }
}
