/*
Chương 2: Hợp đồng Ownable
Bạn có phát hiện lỗ hổng bảo mật trong chương trước không?
Hợp đồng Ownable trong Solidity là một loại hợp đồng thông minh có cơ chế quản lý quyền sở hữu. Hợp đồng này giúp đảm bảo rằng chỉ chủ sở hữu (owner)
của hợp đồng có quyền thực hiện một số hành động nhất định, chẳng hạn như thay đổi cài đặt hoặc quản lý hợp đồng.

Hàm setKittyContractAddress là external, nghĩa là bất kỳ ai cũng có thể gọi nó! Điều này có nghĩa là bất cứ ai gọi hàm này đều có thể thay đổi địa chỉ của hợp đồng CryptoKitties và làm hỏng ứng dụng của chúng ta đối với tất cả người dùng.

Chúng ta muốn có khả năng cập nhật địa chỉ này trong hợp đồng, nhưng không muốn mọi người có thể cập nhật nó.

Để xử lý các trường hợp như vậy, một cách thực hành phổ biến đã xuất hiện là tạo các hợp đồng Ownable — nghĩa là chúng có một "chủ sở hữu" (là bạn), người có các đặc quyền đặc biệt.

Hợp đồng Ownable của OpenZeppelin
Dưới đây là hợp đồng Ownable lấy từ thư viện Solidity của OpenZeppelin. OpenZeppelin là một thư viện chứa các hợp đồng thông minh an toàn và được cộng đồng kiểm duyệt mà bạn có thể sử dụng trong DApp của mình. Sau bài học này, chúng tôi khuyến nghị bạn nên truy cập trang web của họ để tiếp tục học hỏi thêm!

Hãy đọc qua hợp đồng dưới đây. Bạn sẽ thấy một số điều mà chúng ta chưa học, nhưng đừng lo lắng, chúng ta sẽ nói về chúng sau.

solidity
/**
 * @title Ownable
 * @dev Hợp đồng Ownable có địa chỉ chủ sở hữu và cung cấp các chức năng kiểm soát ủy quyền cơ bản,
 * điều này đơn giản hóa việc triển khai "quyền người dùng".
 **/
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
   * @dev (Chức năng) Chuyển quyền kiểm soát hợp đồng cho một chủ sở hữu mới.
   * @param (mô tả tham số) newOwner Địa chỉ để chuyển quyền sở hữu.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
/*
Một số điều mới mà chúng ta chưa thấy trước đây:
Constructors: constructor() là một hàm khởi tạo, là một hàm đặc biệt tùy chọn. Nó sẽ chỉ được thực thi một lần duy nhất khi hợp đồng được tạo lần đầu.
Function Modifiers: Modifier onlyOwner(). Modifiers là một dạng nửa hàm được dùng để thay đổi các hàm khác, thường để kiểm tra một số yêu cầu trước khi thực thi. Trong trường hợp này, onlyOwner có thể được sử dụng để giới hạn quyền truy cập, chỉ chủ sở hữu hợp đồng mới có thể chạy hàm này. Chúng ta sẽ nói thêm về modifiers trong chương sau, và về phần kỳ lạ _ ;.
Indexed keyword: không cần lo lắng về từ khóa này, chúng ta chưa cần đến nó.
Vì vậy, hợp đồng Ownable cơ bản thực hiện những điều sau:

Khi hợp đồng được tạo, constructor sẽ đặt chủ sở hữu là msg.sender (người triển khai nó).
Nó thêm modifier onlyOwner, có thể giới hạn quyền truy cập của một số hàm chỉ dành cho chủ sở hữu.
Nó cho phép bạn chuyển quyền sở hữu hợp đồng cho một chủ sở hữu mới.
onlyOwner là một yêu cầu phổ biến trong các hợp đồng, vì vậy hầu hết các DApp Solidity đều bắt đầu bằng cách sao chép/dán hợp đồng Ownable này và hợp đồng đầu tiên của họ sẽ kế thừa từ nó.

Vì chúng ta muốn giới hạn hàm setKittyContractAddress chỉ dành cho onlyOwner, chúng ta sẽ làm tương tự cho hợp đồng của mình.
*/
pragma solidity >=0.5.0 <0.6.0;

// 1. Import here
import "./ownable.sol";
// 2. Inherit here:
contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
