/*
Chương 2: Lắng nghe các sự kiện
Tuyệt vời, bạn đã khởi tạo hợp đồng của mình rồi! 🙌🏻 Bây giờ bạn có thể gọi các hàm của nó.

Nhưng hãy lùi lại một bước để có cái nhìn tổng quan hơn. Bạn có nhớ cách mà ứng dụng JavaScript của bạn được thông báo về các yêu cầu mới không?

Chà... 🤔?

Để mình trả lời cho.

Oracle sẽ phát ra một sự kiện và sự kiện đó sẽ kích hoạt một hành động. Vì vậy, trước khi viết mã để gọi hợp đồng oracle, ứng dụng của bạn cần phải "lắng nghe" các sự kiện.

Dưới đây là một phần tóm tắt nhanh về cách oracle phát ra sự kiện GetLatestEthPriceEvent:

solidity
function getLatestEthPrice() public returns (uint256) {
  randNonce++;
  uint id = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % modulus;
  pendingRequests[id] = true;
  emit GetLatestEthPriceEvent(msg.sender, id);
  return id;
}
Mỗi lần oracle phát ra sự kiện GetLatestEthPriceEvent, ứng dụng của bạn nên nhận sự kiện đó và thêm nó vào mảng pendingRequests.

Dưới đây là một ví dụ về cách lắng nghe một sự kiện:

javascript
myContract.events.EventName(async (err, event) => {
  if (err) {
    console.error('Error on event', err)
    return
  }
  // Làm gì đó
})
Đoạn mã trên chỉ lắng nghe sự kiện có tên là EventName. Đối với các trường hợp phức tạp hơn, bạn có thể chỉ định bộ lọc như sau:

javascript
myContract.events.EventName({ filter: { myParam: 1 }}, async (err, event) => {
  if (err) {
    console.error('Error on event', err)
    return
  }
  // Làm gì đó
})
Đoạn mã trên chỉ kích hoạt khi có sự kiện mà myParam bằng 1.
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

async function getOracleContract (web3js) {
  const networkId = await web3js.eth.net.getId()
  return new web3js.eth.Contract(OracleJSON.abi, OracleJSON.networks[networkId].address)
}

// Start here
async function filterEvents(oracleContract  , web3js) {
  oracleContract.events.GetLatestEthPriceEvent(async (err, event) => {
  if (err) {
    console.error('Error on event', err)
    return
  }
    await addRequestToQueue(event)
})
oracleContract.events.SetLatestEthPriceEvent(async (err, event) => {
  if (err) {
    console.error('Error on event', err)
    return
  }
})
}
