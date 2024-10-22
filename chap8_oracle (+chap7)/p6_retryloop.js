/*
Chương 6: Vòng lặp thử lại
Bây giờ, việc lấy giá ETH từ API công cộng của Binance đi kèm với một số khía cạnh đáng chú ý.

Một mặt, giả sử bạn thực hiện một yêu cầu nhưng có sự cố mạng. Nếu vậy, yêu cầu sẽ thất bại.
Nếu bạn chỉ để điều đó xảy ra, hợp đồng người gọi sẽ phải khởi động lại toàn bộ quy trình từ đầu, ngay cả khi trong vòng vài giây, kết nối mạng đã được khôi phục. 
Đúng vậy, điều này không đủ mạnh mẽ. Chúng ta có nghĩ đến cùng một giải pháp không? Hãy xem nào. Cách tôi sẽ thực hiện điều này là triển khai một cơ chế thử lại.

Vì vậy, khi xảy ra lỗi, ứng dụng sẽ bắt đầu thử lại. Nhưng, mặt khác, nếu có một vấn đề lớn hơn (như địa chỉ của API đã bị thay đổi), ứng dụng của bạn có thể bị kẹt trong một vòng lặp vô hạn.

Do đó, bạn sẽ cần một điều kiện để thoát khỏi vòng lặp thử lại nếu cần thiết.

Tương tự như cách bạn đã làm trong Chương 4, bạn sẽ viết một khối while. Nhưng lần này, bạn sẽ tăng một biến sau mỗi lần lặp và vòng lặp sẽ kiểm tra xem biến đó có nhỏ hơn MAX_RETRIES hay không.

Thật đơn giản phải không?
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
    const req = pendingRequests.shift()
    await processRequest(oracleContract, ownerAddress, req.id, req.callerAddress)
    processedRequests++
  }
}

// Start here
async function processRequest (oracleContract, ownerAddress, id, callerAddress){
  let retries = 0
  while (retries < MAX_RETRIES){
    try {
 // Do something
} catch (error) {
 // Do some other thing
}
  }
}
