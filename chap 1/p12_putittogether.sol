/*
Chương 12: Hoàn thiện

Chúng ta sắp hoàn thành bộ tạo Zombie ngẫu nhiên! Hãy tạo một hàm public để kết nối tất cả các phần lại với nhau.

Chúng ta sẽ tạo một hàm public nhận đầu vào là tên của zombie và sử dụng tên đó để tạo một zombie với DNA ngẫu nhiên.

*/
pragma solidity  >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // start here
    function createRandomZombie(string memory _name) public    
    {
       uint randDna = _generateRandomDna(_name);
       _createZombie(_name, randDna);
    }  

}
