# Chương 13: Triển khai Hợp Đồng

Trong chương này, chúng tôi sẽ hướng dẫn ngắn gọn quy trình triển khai các smart contract của bạn lên Extdev Testnet.

> **Lưu ý**: Chúng tôi sẽ không đi sâu vào chi tiết về cách Truffle hoạt động. Nếu bạn muốn tìm hiểu thêm, hãy tham khảo bài học *Deploying DApps with Truffle* để có thêm kiến thức.

## Tạo Khóa Bí Mật (Private Keys)

Trước khi triển khai hợp đồng, bạn cần tạo hai khóa bí mật: một cho caller contract và một cho oracle. Để làm điều này, bạn có thể sử dụng đoạn script sau:

1. Tạo thư mục có tên `scripts` và trong đó, tạo file `gen-key.js`.
2. Dán đoạn mã dưới đây:

```javascript
const { CryptoUtils } = require('loom-js')
const fs = require('fs')

if (process.argv.length <= 2) {
    console.log("Usage: " + __filename + " <filename>.")
    process.exit(1);
}

const privateKey = CryptoUtils.generatePrivateKey()
const privateKeyString = CryptoUtils.Uint8ArrayToB64(privateKey)

let path = process.argv[2]
fs.writeFileSync(path, privateKeyString)
 ````
Bạn có thể tạo khóa bí mật cho oracle bằng cách chạy lệnh:
```bash
node scripts/gen-key.js oracle/oracle_private_key

```
Tương tự, để tạo khóa bí mật cho caller contract, chạy lệnh:
```bash
node scripts/gen-key.js caller/caller_private_key

```
## Cấu Hình Truffle
Tiếp theo, bạn cần cấu hình Truffle để triển khai trên Extdev Testnet. Do oracle và caller contract sử dụng các khóa riêng biệt, cách đơn giản nhất là tạo các cấu hình riêng.

Đối với oracle, tạo file oracle/truffle-config.js với nội dung sau:
``` javascript
const LoomTruffleProvider = require('loom-truffle-provider')
const path = require('path')
const fs = require('fs')

module.exports = {
  networks: {
    extdev: {
      provider: function () {
        const privateKey = fs.readFileSync(path.join(__dirname, 'oracle_private_key'), 'utf-8')
        const chainId = 'extdev-plasma-us1'
        const writeUrl = 'wss://extdev-plasma-us1.dappchains.com/websocket'
        const readUrl = 'wss://extdev-plasma-us1.dappchains.com/queryws'
        return new LoomTruffleProvider(chainId, writeUrl, readUrl, privateKey)
      },
      network_id: '9545242630824'
    }
  },
  compilers: {
    solc: {
      version: '0.5.0'
    }
  }
}
```
Đối với caller contract, tạo file caller/truffle-config.js và sửa dòng này:
```javascript
const privateKey = fs.readFileSync(path.join(__dirname, 'oracle_private_key'), 'utf-8')
thành:
```
```javascript
const privateKey = fs.readFileSync(path.join(__dirname, 'caller_private_key'), 'utf-8')
```
Tạo File Migration
Để triển khai oracle contract, tạo file ./oracle/migrations/2_eth_price_oracle.js với nội dung sau:

```javascript
const EthPriceOracle = artifacts.require('EthPriceOracle')

module.exports = function (deployer) {
  deployer.deploy(EthPriceOracle)
}
```
Tương tự, để triển khai caller contract, tạo file ./caller/migrations/02_caller_contract.js với nội dung:

```javascript
const CallerContract = artifacts.require('CallerContract')

module.exports = function (deployer) {
  deployer.deploy(CallerContract)
}
```
Cập Nhật File package.json
Tại thời điểm này, bạn đã sẵn sàng triển khai các hợp đồng. Tuy nhiên, bạn sẽ cần nhập các lệnh sau:

```bash
cd oracle && npx truffle migrate --network extdev --reset --all && cd ..
```
và tiếp theo:
```bash
cd caller && npx truffle migrate --network extdev --reset --all && cd ..
```
Để tránh việc nhập lại lệnh nhiều lần, hãy chỉnh sửa phần scripts trong file package.json thành:

```json
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "deploy:oracle": "cd oracle && npx truffle migrate --network extdev --reset --all && cd ..",
    "deploy:caller": "cd caller && npx truffle migrate --network extdev --reset --all && cd ..",
    "deploy:all": "npm run deploy:oracle && npm run deploy:caller"
}
```
Bây giờ, bạn có thể triển khai hợp đồng dễ dàng hơn bằng cách chạy:

```bash
npm run deploy:all
```
![image](https://github.com/user-attachments/assets/55065f81-bbf5-4291-8f9d-b02083a586f8)
