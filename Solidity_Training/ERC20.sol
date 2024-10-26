// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// Giao diện tiêu chuẩn của ERC20 token 
// ----------------------------------------------------------------------------
contract ERC20Interface {
    // Lấy tổng nguồn cung của token
    function totalSupply() public view returns (uint);

    // Lấy số dư của chủ sở hữu token
    function balanceOf(address tokenOwner) public view returns (uint balance);

    // Kiểm tra số lượng token mà spender được phép tiêu từ tokenOwner
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    // Chuyển tokens tới địa chỉ '_to' trả về giao dịch succes hoặc không
    function transfer(address to, uint tokens) public returns (bool success);

    // Cho phép 'spender' tiêu số lượng token
    function approve(address spender, uint tokens) public returns (bool success);

    // Chuyển token từ 'from' tới 'to' thông qua cơ chế allowance
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    // Sự kiện khi có chuyển token
    event Transfer(address indexed from, address indexed to, uint tokens);

    // Sự kiện khi một tài khoản cấp quyền cho tài khoản khác
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// Safe Math Library - Thư viện giúp tránh lỗi tràn số
// ----------------------------------------------------------------------------
contract SafeMath {
    // Cộng 2 số và đảm bảo không xảy ra lỗi tràn
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a); // Kiểm tra xem có xảy ra tràn số không
    }

    // Trừ 2 số và đảm bảo không xảy ra lỗi
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); // Đảm bảo a >= b
        c = a - b;
    }

    // Nhân 2 số và đảm bảo kết quả hợp lệ
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b); // Đảm bảo không xảy ra tràn số
    }

    // Chia 2 số và đảm bảo không chia cho 0
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0); // Đảm bảo b > 0
        c = a / b;
    }
}

// ----------------------------------------------------------------------------
// Contract CongDat - Token dựa trên ERC20
// ----------------------------------------------------------------------------
contract CongDat is ERC20Interface {
    // Các thông tin cơ bản của token
    string public name;     // Tên của token
    string public symbol;   // Ký hiệu của token
    uint8 public decimals;  // Số thập phân (đề xuất là 18)

    uint256 public _totalSupply;  // Tổng nguồn cung

    // Mapping để lưu trữ số dư của các địa chỉ
    mapping(address => uint) balances;
    // Mapping để lưu số lượng token mà 'tokenOwner' cho phép 'spender' tiêu
    mapping(address => mapping(address => uint)) allowed;

    // Hàm khởi tạo (constructor)
    constructor() public {
        name = "CongDat"; // Đặt tên token
        symbol = "CDT";   // Đặt ký hiệu token
        decimals = 18;    // Số thập phân là 18
        _totalSupply = 100000000000000000000000000; // Tổng cung là 100 triệu CDT với 18 chữ số thập phân

        // Chuyển toàn bộ tổng cung tới người tạo hợp đồng
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Lấy tổng cung token trừ đi số token không sử dụng
    function totalSupply() public view returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    // Lấy số dư của tài khoản
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    // Kiểm tra số token mà spender có thể tiêu từ tokenOwner
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // Phê duyệt cho 'spender' tiêu số token từ tài khoản của người gọi
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Chuyển tokens tới địa chỉ 'to'
    function transfer(address to, uint tokens) public returns (bool success) {
        // Trừ tokens từ người gửi
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        // Cộng tokens tới người nhận
        balances[to] = safeAdd(balances[to], tokens);
        // Phát sự kiện chuyển token
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // Chuyển tokens từ 'from' tới 'to'
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens); // Trừ số dư của người gửi
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); // Trừ số token được phê duyệt
        balances[to] = safeAdd(balances[to], tokens); // Cộng số dư vào tài khoản người nhận
        emit Transfer(from, to, tokens); // Phát sự kiện
        return true;
    }
}
