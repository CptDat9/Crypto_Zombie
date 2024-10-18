/*
Chương 2: Gọi Các Hợp Đồng Khác

Bây giờ, thay vì nhảy trực tiếp vào hợp đồng thông minh oracle, chúng ta sẽ tiếp tục xem xét hợp đồng thông minh gọi (caller contract). Điều này giúp bạn hiểu rõ hơn về quy trình từ đầu đến cuối.

Một trong những việc mà hợp đồng thông minh gọi làm là tương tác với oracle. Hãy xem làm thế nào bạn có thể thực hiện việc này.

Để hợp đồng thông minh gọi có thể tương tác với oracle, bạn phải cung cấp cho nó những thông tin sau:

Địa chỉ của hợp đồng thông minh oracle
Chữ ký của hàm mà bạn muốn gọi
Tôi cho rằng cách đơn giản nhất là chỉ cần mã hóa sẵn địa chỉ của hợp đồng oracle.

Nhưng hãy đội mũ phát triển blockchain của chúng ta 🎩 và thử nghĩ xem liệu đây có phải là điều chúng ta muốn làm không.

Câu trả lời liên quan đến cách thức hoạt động của các blockchain. Có nghĩa là, khi một hợp đồng đã được triển khai, bạn không thể cập nhật nó. Như những người bản xứ gọi, các hợp đồng là bất biến.

Nếu bạn nghĩ kỹ, bạn sẽ thấy có rất nhiều trường hợp bạn muốn cập nhật địa chỉ của oracle. Ví dụ, giả sử có một lỗi và oracle phải được triển khai lại. Vậy thì sao? Bạn sẽ phải triển khai lại tất cả mọi thứ và cập nhật lại giao diện người dùng.

Ừm, điều này khá tốn kém, mất thời gian và ảnh hưởng xấu đến trải nghiệm người dùng 😣.

Vì vậy, cách bạn muốn làm là viết một hàm đơn giản để lưu trữ địa chỉ của hợp đồng oracle vào một biến. Sau đó, bạn sẽ khởi tạo hợp đồng oracle để hợp đồng của bạn có thể gọi các hàm của nó bất kỳ lúc nào.
*/
pragma solidity 0.5.0;
contract CallerContract {
    // start here
    address private oracleAddress;
    function setOracleInstanceAddress (address _oracleInstanceAddress) public{
        oracleAddress = _oracleInstanceAddress;
    }
}
