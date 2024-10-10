Chương 3: balanceOf và ownerOf

Tuyệt vời, hãy bắt đầu với việc triển khai ERC721!

Chúng ta đã sao chép bộ khung trống của tất cả các hàm mà bạn sẽ triển khai trong bài học này.

Trong chương này, chúng ta sẽ triển khai hai phương thức đầu tiên: balanceOf và ownerOf.

balanceOf
solidity
function balanceOf(address _owner) external view returns (uint256 _balance);
Hàm này đơn giản nhận vào một địa chỉ và trả về số lượng token mà địa chỉ đó sở hữu.

Trong trường hợp của chúng ta, "token" chính là các Zombie. Bạn có nhớ chúng ta đã lưu trữ số lượng zombie mà một chủ sở hữu có ở đâu trong DApp không?

ownerOf
solidity
function ownerOf(uint256 _tokenId) external view returns (address _owner);
Hàm này nhận vào một ID token (trong trường hợp của chúng ta là ID của Zombie) và trả về địa chỉ của người sở hữu nó.

Một lần nữa, điều này rất dễ triển khai vì chúng ta đã có một phép ánh xạ (mapping) trong DApp lưu trữ thông tin này. Chúng ta có thể triển khai hàm này chỉ bằng một dòng lệnh, đó là một câu lệnh return.

Lưu ý: Nhớ rằng uint256 tương đương với uint. Từ trước đến nay chúng ta đã sử dụng uint trong mã của mình, nhưng chúng ta sử dụng uint256 ở đây vì chúng ta sao chép từ tiêu chuẩn.
-----------------------------------------------------------------------------
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  function balanceOf(address _owner) external view returns (uint256) {
    // 1. Return the number of zombies `_owner` has here
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    // 2. Return the owner of `_tokenId` here
    return zombieToOwner[_tokenId];
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {

  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }
}
