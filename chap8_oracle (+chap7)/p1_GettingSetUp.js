/*
Chương 1: Cài Đặt Môi Trường
Trong bài học này, bạn sẽ tạo phần JavaScript của oracle để lấy giá ETH từ API của Binance. Sau đó, bạn sẽ xây dựng một client cơ bản tương tác với oracle.

Hãy nhìn vào màn hình bên phải. Để chuẩn bị mọi thứ cho bạn, chúng tôi đã:

Tạo một tệp JavaScript mới có tên là EthPriceOracle.js
Nhập một loạt các thư viện cần thiết
Khởi tạo một vài biến
Điền vào một số đoạn mã cơ bản để kết nối ứng dụng của bạn với Extdev Testnet (tham khảo tab utils/common.js để biết chi tiết).
Những điều cần lưu ý:
Chúng tôi đã nhập các build artifacts (các thành phần xây dựng) và lưu chúng trong một biến hằng số gọi là OracleJSON. Nếu bạn không nhớ từ các bài học trước, build artifacts là gì, đây là một tóm tắt nhanh: build artifacts bao gồm các phiên bản mã bytecode của hợp đồng thông minh, ABI, và một số dữ liệu nội bộ mà Truffle sử dụng để triển khai mã đúng cách.
ABI là gì?
Tóm lại, ABI (Application Binary Interface) mô tả giao diện giữa hai chương trình máy tính. Đừng nhầm lẫn với API (Application Programming Interface), thứ định nghĩa giao diện ở cấp độ cao hơn (mã nguồn). ABI mô tả cách các hàm có thể được gọi và cách dữ liệu được lưu trữ ở định dạng máy có thể đọc được. Ví dụ, đây là cách thuộc tính pendingRequests của hợp đồng oracle được mô tả:

json
{
  "constant": false,
  "id": 143,
  "name": "pendingRequests",
  "nodeType": "VariableDeclaration",
  "scope": 240,
  "src": "229:38:2",
  "stateVariable": true,
  "storageLocation": "default",
  "typeDescriptions": {
    "typeIdentifier": "t_mapping$_t_uint256_$_t_bool_$",
    "typeString": "mapping(uint256 => bool)"
  }
}
Bạn có cảm thấy vui khi sử dụng các ngôn ngữ bậc cao như JavaScript và Solidity, giúp bạn tránh xa tất cả sự phức tạp này không? Tôi chắc chắn là có 🤓!

Chúng tôi đã khởi tạo một mảng trống gọi là pendingRequests. Bạn sẽ sử dụng nó sau để theo dõi các yêu cầu đến.

☞ Dành vài phút để đọc qua đoạn mã trước khi tiếp tục!

Khởi Tạo Hợp Đồng Oracle
Build artifacts nằm trong một tệp JSON và chúng tôi đã nhập chúng bằng dòng mã sau:

javascript
const OracleJSON = require('./oracle/build/contracts/EthPriceOracle.json')
Ví dụ, dựa trên thông tin được lưu trữ trong tệp này, ứng dụng của bạn biết rằng hàm setLatestEthPrice nhận ba tham số uint256 (_ethPrice, _callerAddress, và _id), và nó có thể tạo một giao dịch gọi hàm này.

Nhưng trước khi thực hiện điều đó, để tương tác với một hợp đồng đã triển khai từ JavaScript, bạn cần khởi tạo nó bằng web3.eth.Contract. Hãy xem một ví dụ để làm rõ khái niệm này:

javascript
const myContract = new web3js.eth.Contract(myContractJSON.abi, myContractJSON.networks[networkId].address)
Lưu ý rằng ví dụ trên sử dụng một biến gọi là networkId, biến này xác định mạng mà hợp đồng của bạn đã được triển khai. networkId cho Extdev là 9545242630824, vì vậy bạn có thể khai báo biến networkId như sau:

javascript
const networkId = 9545242630824
Dễ dàng đúng không! Nhưng dù dòng mã trên trông có vẻ đơn giản, nó không phải là một ý tưởng tốt để mã hóa cứng identifier của mạng như vậy. Tại sao không? Bởi vì làm như vậy sẽ yêu cầu bạn cập nhật networkId mỗi khi hợp đồng của bạn được triển khai trên một mạng khác.

Giải pháp tốt hơn là lấy networkId bằng cách gọi hàm web3js.eth.net.getId():

javascript
const networkId = await web3js.eth.net.getId()
*/
const axios = require('axios')
const BN = require('bn.js')
const common = require('./utils/common.js')
const SLEEP_INTERVAL = process.env.SLEEP_INTERVAL || 2000
const PRIVATE_KEY_FILE_NAME = process.env.PRIVATE_KEY_FILE || './oracle/oracle_private_key'
const CHUNK_SIZE = process.env.CHUNK_SIZE || 3
const MAX_RETRIES = process.env.MAX_RETRIES || 5
const OracleJSON = require('./oracle/build/contracts/EthPriceOracle.json')
var pendingRequests = []

// Start here
async function getOracleContract(web3js){
    const networkId = await web3js.eth.net.getId()
    return new web3js.eth.Contract(OracleJSON.abi, OracleJSON.networks[networkId].address)
}
