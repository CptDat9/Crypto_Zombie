/*
Chương 8: Tiếp tục sử dụng Try và Catch trong JavaScript
Tuyệt vời, bạn đã hoàn thành việc mã hóa khối try 💪🏻! Bây giờ, chúng ta hãy chuyển sang khối catch. Nhớ rằng, các dòng mã này sẽ được thực thi nếu một ngoại lệ xảy ra trong khối try.

Logic của khối catch sẽ như sau:

Đầu tiên, bạn cần xác định xem số lần thử lại tối đa đã đạt hay chưa. Để làm điều này, bạn sẽ sử dụng một câu lệnh if tương tự như dưới đây:

javascript
if (condition) {
  doSomething()
}
Nếu điều kiện được đánh giá là đúng, nghĩa là số lần thử lại tối đa đã đạt, thì bạn cần thông báo cho hợp đồng rằng có sự cố xảy ra và oracle không thể trả về một phản hồi hợp lệ. 
Cách đơn giản nhất để làm điều này là gọi hàm setLatestEthPrice và truyền giá trị 0 làm giá ETH.

Nếu điều kiện được đánh giá là sai, nghĩa là số lần thử lại chưa đạt mức tối đa, bạn chỉ cần tăng số lần thử lại.

Logic này có thể được triển khai chỉ trong vài dòng mã. Hãy thực hiện những thay đổi sau nhé!
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

async function processRequest (oracleContract, ownerAddress, id, callerAddress) {
  let retries = 0
  while (retries < MAX_RETRIES) {
    try {
      const ethPrice = await retrieveLatestEthPrice()
      await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, ethPrice, id)
      return
    } catch (error) {
      // Start here
      if ( retries === MAX_RETRIES-1){
        await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, '0', id)
        return
      }
      retries++
    }
  }
}
