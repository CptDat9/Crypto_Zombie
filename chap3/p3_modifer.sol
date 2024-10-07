/*
Chương 3: Modifier Hàm onlyOwner
Bây giờ khi hợp đồng cơ sở ZombieFactory kế thừa từ Ownable, chúng ta có thể sử dụng modifier hàm onlyOwner trong ZombieFeeding nữa.

Điều này là do cách mà kế thừa hợp đồng hoạt động. Hãy nhớ:

ZombieFeeding là ZombieFactory
ZombieFactory là Ownable
Do đó, ZombieFeeding cũng là Ownable, và có thể truy cập các hàm/sự kiện/modifier từ hợp đồng Ownable. Điều này cũng áp dụng cho bất kỳ hợp đồng nào kế thừa từ ZombieFeeding trong tương lai.

Function Modifiers
Một function modifier trông giống như một hàm, nhưng sử dụng từ khóa modifier thay vì function. Modifier không thể được gọi trực tiếp như hàm — thay vào đó, ta có thể đính kèm tên của modifier vào cuối một định nghĩa hàm để thay đổi hành vi của hàm đó.

Hãy xem xét kỹ hơn về onlyOwner:
*/
solidity
pragma solidity >=0.5.0 <0.6.0;

/**
 * @title Ownable
 * @dev Hợp đồng Ownable có địa chỉ chủ sở hữu và cung cấp các chức năng kiểm soát ủy quyền cơ bản.
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev Constructor của Ownable thiết lập chủ sở hữu ban đầu của hợp đồng là tài khoản người gửi (msg.sender).
   */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return địa chỉ của chủ sở hữu.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Kích hoạt lỗi nếu hàm được gọi bởi tài khoản không phải là chủ sở hữu.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true nếu `msg.sender` là chủ sở hữu của hợp đồng.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Cho phép chủ sở hữu hiện tại từ bỏ quyền kiểm soát hợp đồng.
   * @notice Từ bỏ quyền sở hữu sẽ khiến hợp đồng không còn chủ sở hữu.
   * Sẽ không thể gọi các hàm có modifier `onlyOwner` nữa.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Cho phép chủ sở hữu hiện tại chuyển quyền kiểm soát hợp đồng cho một chủ sở hữu mới.
   * @param newOwner Địa chỉ để chuyển quyền sở hữu.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Chuyển quyền kiểm soát hợp đồng cho một chủ sở hữu mới.
   * @param newOwner Địa chỉ để chuyển quyền sở hữu.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
/*
Chú ý modifier onlyOwner trên hàm renounceOwnership. Khi bạn gọi renounceOwnership, mã bên trong onlyOwner sẽ được thực thi trước. Sau đó khi gặp lệnh _ ; trong onlyOwner, nó sẽ quay lại và thực thi mã bên trong renounceOwnership.

Mặc dù có những cách khác để sử dụng modifiers, một trong những trường hợp sử dụng phổ biến nhất là thêm một lệnh kiểm tra nhanh require trước khi một hàm được thực thi.

Trong trường hợp onlyOwner, thêm modifier này vào một hàm giúp đảm bảo chỉ chủ sở hữu của hợp đồng (là bạn, nếu bạn triển khai nó) mới có thể gọi hàm đó.

Lưu ý: Việc trao quyền đặc biệt cho chủ sở hữu hợp đồng như thế này thường là cần thiết, nhưng cũng có thể bị sử dụng một cách ác ý. Ví dụ, chủ sở hữu có thể thêm một hàm cửa sau cho phép anh ta chuyển các zombie của bất kỳ ai cho chính mình!

Do đó, điều quan trọng là phải nhớ rằng chỉ vì một DApp nằm trên Ethereum không có nghĩa là nó tự động phi tập trung — bạn cần phải đọc toàn bộ mã nguồn để đảm bảo rằng nó không chứa các kiểm soát đặc biệt của chủ sở hữu mà bạn cần phải lo ngại. Với tư cách là một nhà phát triển, bạn cần phải cân nhắc giữa việc duy trì quyền kiểm soát DApp để sửa các lỗi tiềm năng và xây dựng một nền tảng không có chủ sở hữu mà người dùng của bạn có thể tin tưởng bảo mật dữ liệu của họ.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

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

  KittyInterface kittyContract;

  // Modify this function:
  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}







