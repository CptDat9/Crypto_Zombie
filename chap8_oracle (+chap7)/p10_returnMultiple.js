/*
Chương 10: Trả về nhiều giá trị trong JavaScript
Logic của hàm retrieveLatestEthPrice rất đơn giản để triển khai, nên chúng ta sẽ không mất nhiều thời gian để giải thích. Mã đã được đặt dưới hàm getOracleContract. Hãy đọc qua để hiểu cách nó hoạt động.

Tin tốt là bạn gần hoàn thành việc tạo oracle. Tuy nhiên, vẫn còn một vài điều nhỏ bạn cần làm. Ví dụ, hãy xem điều gì xảy ra khi bạn khởi động oracle.

Mỗi lần oracle khởi động, nó cần phải:

Kết nối với Extdev TestNet bằng cách gọi hàm common.loadAccount.
Khởi tạo hợp đồng oracle.
Bắt đầu lắng nghe các sự kiện.
Để giữ mã nguồn gọn gàng, bạn nên đặt tất cả những thứ này vào một hàm. Hàm này sẽ trả về một loạt các giá trị cần thiết cho các hàm khác:

client: một đối tượng ứng dụng sử dụng để tương tác với Extdev TestNet,
Instance của hợp đồng oracle, và
ownerAddress: địa chỉ được sử dụng trong setLatestEthPrice để chỉ định địa chỉ gửi giao dịch.
Đây là một chút thách thức vì trong JavaScript, hàm không thể trả về nhiều giá trị. Nhưng điều này không ngăn cản một hàm trả về... một đối tượng hoặc một mảng, đúng không?

Chính xác. Đây là cách bạn có thể đạt được kết quả tương tự trong JavaScript bằng cách sử dụng một đối tượng:

javascript
function myAwesomeFunction () {
  const one = '1'
  const two = '2'
  return { one, two }
}
Sau đó, mã gọi hàm này phải giải nén các giá trị:

javascript
const { one, two } = myAwesomeFunction()
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

async function retrieveLatestEthPrice () {
  const resp = await axios({
    url: 'https://api.binance.com/api/v3/ticker/price',
    params: {
      symbol: 'ETHUSDT'
    },
    method: 'get'
  })
  return resp.data.price
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
      if (retries === MAX_RETRIES - 1) {
        await setLatestEthPrice(oracleContract, callerAddress, ownerAddress, '0', id)
        return
      }
      retries++
    }
  }
}

async function setLatestEthPrice (oracleContract, callerAddress, ownerAddress, ethPrice, id) {
  ethPrice = ethPrice.replace('.', '')
  const multiplier = new BN(10**10, 10)
  const ethPriceInt = (new BN(parseInt(ethPrice), 10)).mul(multiplier)
  const idInt = new BN(parseInt(id))
  try {
    await oracleContract.methods.setLatestEthPrice(ethPriceInt.toString(), callerAddress, idInt.toString()).send({ from: ownerAddress })
  } catch (error) {
    console.log('Error encountered while calling setLatestEthPrice.')
    // Do some error handling
  }
}

async function init () {
  // Start here
  const { ownerAddress, web3js, client } = common.loadAccount(PRIVATE_KEY_FILE_NAME)

const oracleContract = await getOracleContract(web3js)
await filterEvents(oracleContract, web3js)
return {oracleContract, ownerAddress, client}
}
