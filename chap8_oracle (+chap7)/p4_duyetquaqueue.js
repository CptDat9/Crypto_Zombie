/*
Chương 4: Duyệt qua hàng đợi xử lý
Sau khi đã viết xong hàm để thêm yêu cầu mới mỗi khi hợp đồng oracle phát ra sự kiện GetLatestEthPriceEvent, nhiệm vụ tiếp theo của bạn là xử lý các yêu cầu này.

Hãy tưởng tượng có nhiều hợp đồng người gọi đang gửi yêu cầu đến oracle của bạn. Việc xử lý mảng pendingRequests trong Node.js có thể gặp vấn đề vì một lý do rất đơn giản: JavaScript chỉ có một luồng (single-threaded). Điều này có nghĩa là mọi thao tác khác sẽ bị chặn cho đến khi quá trình xử lý hoàn tất.

Một kỹ thuật để giải quyết vấn đề này là chia mảng thành các khối nhỏ hơn (tối đa là MAX_CHUNK_SIZE) và xử lý từng khối riêng biệt. Để đơn giản hóa, sau mỗi khối, ứng dụng sẽ ngủ trong một khoảng thời gian SLEEP_INTERVAL mili giây.

Bạn sẽ thực hiện điều này bằng một vòng lặp while.

Vòng lặp while bao gồm một điều kiện được đánh giá tại mỗi lần lặp và mã sẽ được thực thi. Điều kiện được đặt trong dấu ngoặc đơn và mã nằm trong dấu ngoặc nhọn:

javascript
let counter = 0
while ( counter <= 10 ) {
  console.log(counter)
  counter++
}
Nhưng nếu hai điều kiện cần phải được thỏa mãn để mã trong dấu ngoặc nhọn được thực thi thì sao? Nếu vậy, bạn có thể kiểm tra hai điều kiện (hoặc nhiều hơn) bằng cách kết hợp chúng với toán tử logic AND (&&):

javascript
let counter = 0
while ( counter <= 10 && isNotMonday ) {
  console.log(counter)
  counter++
}
Đoạn mã trên sẽ không làm gì vào thứ Hai .

Nói vậy, hãy viết hàm để chia mảng này thành các phần nhỏ hơn nhé.
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

// Start here
async function processQueue(oracleContract, ownerAddress){
  let processedRequests = 0
  while (pendingRequests.length > 0 && processedRequests <CHUNK_SIZE)
  {

  }
}
