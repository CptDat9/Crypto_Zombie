/*
Chương 9: Làm việc với số trong Ethereum và JavaScript
Nhớ rằng chúng ta đã đề cập rằng dữ liệu cần được xử lý một chút trước khi gửi đến hợp đồng oracle. Hãy xem lý do tại sao.

Máy ảo Ethereum (EVM) không hỗ trợ số dạng dấu phẩy động (floating-point numbers), điều này có nghĩa là khi thực hiện phép chia, p
hần thập phân sẽ bị loại bỏ. Giải pháp đơn giản là nhân các con số trong front-end của bạn với 10^n. API của Binance trả về số có 8 chữ số thập phân và chúng ta sẽ nhân con số này với 10^10.
Tại sao lại chọn 10^10? Vì 1 ether bằng 10^18 wei. Bằng cách này, chúng ta sẽ chắc chắn rằng không có sai sót về giá trị tiền tệ.

Nhưng còn nhiều điều hơn thế. Kiểu Number trong JavaScript là "giá trị nhị phân 64-bit định dạng IEEE 754" chỉ hỗ trợ 16 chữ số thập phân...

May mắn thay, có một thư viện nhỏ tên là BN.js sẽ giúp bạn giải quyết những vấn đề này.

☞ Vì lý do trên, nên luôn sử dụng BN.js khi làm việc với số trong Ethereum.

Bây giờ, API của Binance trả về một thứ như 169.87000000.

Hãy xem cách chuyển đổi giá trị này thành BN.

Đầu tiên, bạn cần loại bỏ dấu thập phân (dấu chấm). Vì JavaScript là ngôn ngữ có kiểu động (cách nói hoa mỹ để chỉ rằng trình thông dịch phân tích giá trị của các biến khi chạy chương trình và,
dựa trên giá trị đó, nó gán kiểu dữ liệu), cách dễ nhất để làm điều này là...

javascript
aNumber = aNumber.replace('.', '')
Tiếp tục với ví dụ này, chuyển đổi aNumber thành BN sẽ trông như thế này:

javascript
const aNumber = new BN(aNumber, 10)
Lưu ý: Tham số thứ hai đại diện cho hệ cơ số. Hãy đảm bảo luôn chỉ định nó.

Chúng ta đã điền hầu hết mã cho hàm setLatestEthPrice. Đây là phần còn lại bạn cần làm.
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
  // Start here
  ethPrice = ethPrice.replace('.', '')
  const multiplier = new BN(10**10 , 10)
  const ethPriceInt = (new BN(parseInt(ethPrice), 10)).mul(multiplier)
  const idInt = new BN(parseInt(id))
  try {
    await oracleContract.methods.setLatestEthPrice(ethPriceInt.toString(), callerAddress, idInt.toString()).send({ from: ownerAddress })
  } catch (error) {
    console.log('Error encountered while calling setLatestEthPrice.')
    // Do some error handling
  }
}
