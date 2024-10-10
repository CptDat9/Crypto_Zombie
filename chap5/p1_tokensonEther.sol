/*
Chương 1: Token trên Ethereum

Hãy nói về token.

Nếu bạn đã ở trong không gian Ethereum một thời gian, chắc hẳn bạn đã nghe nói về các token — cụ thể là các token ERC20.

Một token trên Ethereum về cơ bản chỉ là một hợp đồng thông minh (smart contract) tuân theo một số quy tắc chung — nghĩa là nó triển khai một tập hợp các hàm chuẩn mà tất cả các hợp đồng token khác cùng chia sẻ,
chẳng hạn như transferFrom(address _from, address _to, uint256 _amount) và balanceOf(address _owner).

Bên trong, hợp đồng thông minh thường có một phép ánh xạ mapping(address => uint256) balances để theo dõi số dư của từng địa chỉ.

Vì vậy, về cơ bản, một token chỉ là một hợp đồng giữ vai trò theo dõi ai sở hữu bao nhiêu token, và cung cấp một số hàm để người dùng có thể chuyển token của họ đến các địa chỉ khác.

Tại sao điều này quan trọng?
Vì tất cả các token ERC20 đều có cùng một tập hợp các hàm với cùng tên, chúng có thể tương tác với nhau theo cùng một cách.

Điều này có nghĩa là nếu bạn xây dựng một ứng dụng có khả năng tương tác với một token ERC20, nó cũng có thể tương tác với bất kỳ token ERC20 nào khác.
Điều này giúp các token mới dễ dàng được thêm vào ứng dụng của bạn trong tương lai mà không cần phải viết lại mã. Bạn chỉ cần cắm địa chỉ hợp đồng token mới vào, và thế là ứng dụng của bạn có thêm một token có thể sử dụng.

Một ví dụ về điều này là một sàn giao dịch. Khi một sàn giao dịch thêm một token ERC20 mới, về cơ bản nó chỉ cần thêm một hợp đồng thông minh để giao tiếp. 
Người dùng có thể yêu cầu hợp đồng này gửi token đến ví của sàn giao dịch, và sàn có thể yêu cầu hợp đồng gửi token lại cho người dùng khi họ rút.

Sàn giao dịch chỉ cần triển khai logic chuyển tiền này một lần, và khi muốn thêm một token ERC20 mới, chỉ cần thêm địa chỉ hợp đồng mới vào cơ sở dữ liệu.

Các tiêu chuẩn token khác
Token ERC20 rất tuyệt vời cho các loại token hoạt động như tiền tệ. Nhưng chúng không thực sự hữu ích để đại diện cho các zombie trong trò chơi zombie của chúng ta.

Thứ nhất, zombie không thể chia nhỏ như tiền tệ — bạn có thể gửi cho tôi 0.237 ETH, nhưng việc gửi 0.237 của một zombie thì không hợp lý.

Thứ hai, không phải tất cả các zombie đều giống nhau. Zombie cấp 2 "Steve" của bạn hoàn toàn không thể so sánh với zombie cấp 732 "H4XF13LD MORRIS 💯💯😎💯💯" của tôi. (Steve không có cửa!).

Có một tiêu chuẩn token khác phù hợp hơn nhiều cho các tài sản sưu tầm như CryptoZombies — đó là token ERC721.

Token ERC721 không thể thay thế lẫn nhau vì mỗi token được coi là duy nhất và không thể chia nhỏ. Bạn chỉ có thể trao đổi chúng theo đơn vị nguyên, và mỗi token có một ID riêng biệt.
Vì vậy, chúng là lựa chọn hoàn hảo để làm cho zombie của chúng ta có thể giao dịch được.

Lưu ý rằng việc sử dụng một tiêu chuẩn như ERC721 có lợi thế là chúng ta không cần triển khai logic đấu giá hoặc ký quỹ trong hợp đồng của mình để xác định cách người chơi giao dịch / bán zombie của chúng ta.
Nếu tuân thủ tiêu chuẩn này, người khác có thể xây dựng một nền tảng trao đổi cho các tài sản ERC721 có thể giao dịch, và zombie ERC721 của chúng ta có thể được sử dụng trên nền tảng đó.
Do đó, có những lợi ích rõ ràng khi sử dụng một tiêu chuẩn token thay vì tự phát triển logic giao dịch.
*/
    pragma solidity >=0.5.0 <0.6.0;
    import "./zombieattack.sol";
contract ZombieOwnership is ZombieAttack {

    }
