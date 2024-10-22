/*
Chương 3: Thêm một yêu cầu vào hàng đợi xử lý
Trong chương trước, bạn đã thiết lập một hàm có tên là addRequestToQueue được kích hoạt mỗi khi hợp đồng oracle phát ra sự kiện GetLatestEthPriceEvent. Bây giờ, chúng ta sẽ điền phần thân của hàm này.

Đây là những gì hàm này cần làm:

Đầu tiên, nó cần lấy địa chỉ người gọi và định danh của yêu cầu. Lưu ý rằng bạn có thể truy cập các giá trị trả về của một sự kiện thông qua đối tượng returnValues. Giả sử sự kiện của bạn được định nghĩa như thế này:

solidity
event TransferTokens(address from, address to, uint256 amount)
Thì mã JavaScript để lấy from, to, và amount sẽ tương tự như sau:

javascript
async function parseEvent (event) {
  const from = event.returnValues.from
  const to = event.returnValues.to
  const amount = event.returnValues.amount
}
Hiểu được điều này là bạn đã đi được nửa chặng đường để hiểu hàm addRequestToQueue 🤘🏻.

Thứ hai, hàm này cần gói địa chỉ người gọi (callerAddress) và định danh (id) vào một đối tượng, sau đó đẩy đối tượng này vào mảng pendingRequests. Nghe có vẻ phức tạp, nhưng tin tốt là nó không phức tạp như bạn nghĩ. Hãy xem ví dụ sau về cách đẩy một đối tượng vào một mảng:

javascript
let numbers = [ { 1: 'one' }, { 2: 'two' } ]
numbers.push({ 3: 'three' })
console.log(numbers)
Nếu bạn chạy đoạn mã trên, nó sẽ in ra:

javascript
[ { '1': 'one' }, { '2': 'two' }, { '3': 'three' } ]
Như bạn thấy, đây là một hàm rất đơn giản để viết. Hãy thử viết nó nhé!
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

// Start here
async function addRequestToQueue (event){
  const callerAddress = event.returnValues.callerAddress  
  const id = event.returnValues.id
  pendingRequests.push({callerAddress, id})
}
