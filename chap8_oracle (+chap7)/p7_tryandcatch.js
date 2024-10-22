/*
Chương 7: Sử dụng Try và Catch trong JavaScript
Trong chương trước, bạn đã thêm khối try/catch vào hàm processRequest.

Trước khi tiếp tục với mã, hãy dành vài phút để xem cách hoạt động của try/catch trong JavaScript.

Cách nó hoạt động là mã bên trong khối try sẽ được thực thi và kiểm tra lỗi. Nếu có một ngoại lệ được ném ra, việc thực thi mã bên trong khối try sẽ dừng lại, và chương trình sẽ "nhảy" sang các dòng mã bên trong khối catch.

Lưu ý rằng JavaScript cho phép bạn viết mã thực thi bất kể có ngoại lệ xảy ra hay không trong khối try. Những dòng mã này nên được đặt bên trong khối finally. Bạn sẽ không sử dụng nó trong bài hướng dẫn này, nhưng bạn sẽ không biết khi nào nó có thể hữu ích 🤓.

Với điều đó, hãy quay lại tập trung vào những gì hàm processRequest nên làm. Vậy, bên trong khối try, nó nên gọi retrieveLatestEthPrice và sau đó gọi hợp đồng oracle để đặt giá ETH mới nhất.
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
      // Start here
      const ethPrice = await retrieveLatestEthPrice()
      await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, ethPrice, id)
    return 
    } catch (error) {
    }
  }
}
