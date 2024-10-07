/*
Chương 5: Đơn vị thời gian

Thuộc tính level khá dễ hiểu. Sau này, khi chúng ta tạo hệ thống chiến đấu, những zombie giành nhiều chiến thắng hơn sẽ tăng cấp theo thời gian và có quyền truy cập vào nhiều khả năng hơn.

Thuộc tính readyTime cần giải thích chi tiết hơn. Mục tiêu là thêm một "thời gian hồi chiêu", khoảng thời gian mà một zombie phải chờ sau khi cho ăn hoặc tấn công trước khi nó được phép ăn / tấn công tiếp. Nếu không có điều này, zombie có thể tấn công và sinh sôi hàng nghìn lần mỗi ngày, điều này sẽ làm cho trò chơi quá dễ.

Để theo dõi khoảng thời gian mà zombie phải chờ trước khi có thể tấn công lại, chúng ta có thể sử dụng các đơn vị thời gian của Solidity.

Đơn vị thời gian
Solidity cung cấp một số đơn vị nguyên bản để xử lý thời gian.

Biến now sẽ trả về unix timestamp hiện tại của khối mới nhất (số giây đã trôi qua kể từ ngày 1 tháng 1 năm 1970). Tại thời điểm tôi viết, unix time là 1515527488.

Lưu ý: Unix time truyền thống được lưu trữ trong một số 32-bit. Điều này sẽ dẫn đến vấn đề "Năm 2038", khi mà dấu thời gian 32-bit sẽ tràn số và làm hỏng nhiều hệ thống cũ. Do đó, nếu chúng ta muốn DApp của mình tiếp tục hoạt động sau 20 năm nữa, chúng ta có thể sử dụng số 64-bit thay thế — nhưng người dùng của chúng ta sẽ phải tốn nhiều gas hơn để sử dụng DApp. Quyết định thiết kế!

Solidity cũng chứa các đơn vị thời gian như seconds, minutes, hours, days, weeks, và years. Những đơn vị này sẽ chuyển đổi thành một số nguyên đại diện cho số giây trong khoảng thời gian đó. Vì vậy, 1 phút là 60, 1 giờ là 3600 (60 giây x 60 phút), 1 ngày là 86400 (24 giờ x 60 phút x 60 giây), v.v.

Dưới đây là một ví dụ về cách các đơn vị thời gian này có thể hữu ích:

solidity
uint lastUpdated;

// Đặt `lastUpdated` bằng `now`
function updateTimestamp() public {
  lastUpdated = now;
}

// Trả về `true` nếu đã qua 5 phút kể từ khi hàm `updateTimestamp` được gọi, 
// `false` nếu chưa qua 5 phút
function fiveMinutesHavePassed() public view returns (bool) {
  return (now >= (lastUpdated + 5 minutes));
}
Chúng ta có thể sử dụng các đơn vị thời gian này cho tính năng hồi chiêu của zombie.
*/
pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    // 1. Define `cooldownTime` here
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        // 2. Update the following line:
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now+cooldownTime))) - 1;
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
