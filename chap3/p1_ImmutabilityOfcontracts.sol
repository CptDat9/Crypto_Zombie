/*
Chương 1: Tính bất biến của Hợp đồng

Cho đến nay, Solidity trông khá giống với các ngôn ngữ khác như JavaScript. Nhưng có một số điểm mà các ứng dụng phi tập trung (DApp) trên Ethereum khác hẳn so với các ứng dụng thông thường.

Đầu tiên, sau khi bạn triển khai một hợp đồng (contract) lên Ethereum, nó sẽ trở nên bất biến, nghĩa là nó không bao giờ có thể bị sửa đổi hay cập nhật lại.

Mã ban đầu mà bạn triển khai vào một hợp đồng sẽ tồn tại vĩnh viễn trên blockchain. Đây là một trong những lý do mà vấn đề bảo mật trong Solidity lại là mối quan tâm rất lớn. Nếu có bất kỳ lỗi nào trong mã hợp đồng của bạn, bạn sẽ không có cách nào để sửa nó sau này. Bạn sẽ phải yêu cầu người dùng bắt đầu sử dụng một địa chỉ hợp đồng thông minh khác có bản sửa lỗi.

Nhưng đây cũng chính là một tính năng của các hợp đồng thông minh. Mã là luật. Nếu bạn đọc và xác minh mã của một hợp đồng thông minh, bạn có thể chắc chắn rằng mỗi lần bạn gọi một hàm, nó sẽ thực hiện đúng như những gì mã đã quy định. Không ai có thể thay đổi hàm đó sau này và mang lại những kết quả bất ngờ.

Phụ thuộc bên ngoài
Trong Bài học 2, chúng ta đã gán cứng địa chỉ của hợp đồng CryptoKitties vào DApp của mình. Nhưng điều gì sẽ xảy ra nếu hợp đồng CryptoKitties có lỗi và ai đó tiêu hủy tất cả các con mèo?

Điều này khó có thể xảy ra, nhưng nếu điều đó thực sự xảy ra, nó sẽ khiến DApp của chúng ta hoàn toàn vô dụng — DApp của chúng ta sẽ trỏ đến một địa chỉ đã được gán cứng không còn trả về bất kỳ con mèo nào nữa. Lúc đó, các zombie của chúng ta sẽ không thể feed trên các con mèo, và chúng ta sẽ không thể sửa đổi hợp đồng của mình để khắc phục sự cố.

Vì lý do này, đôi khi sẽ hợp lý hơn nếu có các hàm cho phép bạn cập nhật các phần quan trọng của DApp.

Ví dụ, thay vì gán cứng địa chỉ hợp đồng CryptoKitties vào DApp, chúng ta nên có một hàm setKittyContractAddress cho phép chúng ta thay đổi địa chỉ này trong tương lai, phòng trường hợp có sự cố xảy ra với hợp đồng CryptoKitties.
*/
pragma solidity >=0.5.0 <0.6.0;
import "./zombiefactory.sol";
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  // 3. Add setKittyContractAddress method here
   KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external{
  kittyContract = KittyInterface(_address);
}

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
