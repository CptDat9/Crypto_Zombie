/*
Chương 1: Thiết lập môi trường
Trước khi bắt đầu, cần phải rõ ràng: đây là một bài học ở cấp độ trung cấp và yêu cầu một chút kiến thức về JavaScript và Solidity.

Nếu bạn mới học Solidity, rất khuyến khích bạn nên đi qua các bài học cơ bản trước khi bắt đầu bài này.

Nếu bạn chưa quen với JavaScript, hãy cân nhắc học qua một vài hướng dẫn khác trước khi bắt đầu bài học này.

Bây giờ, giả sử bạn đang xây dựng một ứng dụng DeFi (dApp), và muốn cung cấp cho người dùng khả năng rút ETH với giá trị tương ứng với một số tiền USD nhất định. Để thực hiện yêu cầu này, hợp đồng thông minh của bạn (để đơn giản, chúng ta sẽ gọi nó là "hợp đồng gọi" từ đây trở đi) cần biết giá trị của một Ether.

Và đây là vấn đề: một ứng dụng JavaScript có thể dễ dàng lấy được thông tin này bằng cách gửi yêu cầu đến API công khai của Binance (hoặc bất kỳ dịch vụ nào khác cung cấp dữ liệu giá công khai). Nhưng, một hợp đồng thông minh không thể trực tiếp truy cập dữ liệu từ thế giới bên ngoài. Thay vào đó, nó phải dựa vào một oracle để lấy dữ liệu.

Nghe có vẻ phức tạp lúc ban đầu 🤯. Nhưng, bằng cách chia nhỏ từng bước, chúng ta sẽ giúp bạn dễ dàng vượt qua.

Tôi biết rằng một hình ảnh có giá trị hơn ngàn lời nói, vì vậy đây là một sơ đồ đơn giản để giải thích cách hoạt động của quá trình này:

Sơ đồ Oracle Giá ETH

Hãy để nó thấm dần trước khi bạn tiếp tục đọc.

Bây giờ, chúng ta hãy khởi tạo dự án mới của bạn.
*/
npm init -y
npm i truffle openzeppelin-solidity loom-js loom-truffle-provider bn.js axios
