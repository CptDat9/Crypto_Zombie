/*
Chương 5: Xử lý hàng đợi
Trong chương trước, chúng ta đã tạo một khung rỗng cho hàm processQueue. Bây giờ hãy tập trung vào việc điền nội dung cho nó.

Điều đầu tiên hàm của bạn cần làm là lấy phần tử đầu tiên từ mảng pendingRequests. Tất nhiên, sau khi lấy được, phần tử đó cũng cần phải được xóa khỏi mảng.
Trong JavaScript, bạn có thể làm điều này bằng cách gọi phương thức shift, phương thức này sẽ trả về phần tử đầu tiên của mảng, xóa phần tử đó khỏi mảng và thay đổi độ dài của mảng. Tiếp tục ví dụ từ chương hai, đây là cách shift hoạt động:

javascript
let numbers = [ { 1: 'one' }, { 2: 'two' }, { 3: 'three' } ]
const item = numbers.shift()
console.log(item)
Điều này sẽ in ra { '1': 'one' }.

Sau đó, bạn sẽ phải gọi hàm processRequest. Tôi thấy bạn nhướn mày và hỏi: hàm này thực sự làm gì? Câu trả lời đơn giản là nó... xử lý yêu cầu.
Câu trả lời chi tiết là nó lấy giá ETH, và sau đó gọi hợp đồng thông minh oracle. Đừng lo lắng về nó ngay bây giờ, bạn sẽ viết nó trong các chương sau.

Cuối cùng, bạn sẽ phải tăng biến processedRequests.
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

async function filterEvents (oracleContract, web3js) {
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
    // Do something
  })
}

async function addRequestToQueue (event) {
  const callerAddress = event.returnValues.callerAddress
  const id = event.returnValues.id
  pendingRequests.push({ callerAddress, id })
}

async function processQueue (oracleContract, ownerAddress) {
  let processedRequests = 0
  while (pendingRequests.length > 0 && processedRequests < CHUNK_SIZE) {
    // Start here
    const req = pendingRequests.shift()
    await processRequest(oracleContract, ownerAddress , req.id, req.callerAddress)
    processedRequests++
  }
}
