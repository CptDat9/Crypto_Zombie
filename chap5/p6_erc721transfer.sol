/*
Chapter 6: ERC721: Transfer Cont'd
Great! That was the difficult part — now implementing the external transferFrom function will be easy, since our _transfer function already does almost all the heavy lifting.

Putting it to the Test
First, we want to make sure only the owner or the approved address of a token/zombie can transfer it. Let's define a mapping called zombieApprovals. It should map a uint to an address. This way, when someone that is not the owner calls transferFrom with a _tokenId, we can use this mapping to quickly look up if he is approved to take that token.

Next, let's add a require statement to transferFrom. It should make sure that only the owner or the approved address of a token/zombie can transfer it.

Lastly, don't forget to call _transfer.

Note: Checking that only the owner or the approved address of a token/zombie can transfer it means that at least one of these conditions must be true:

zombieToOwner for _tokenId is equal to msg.sender

or

zombieApprovals for _tokenId is equal to msg.sender

Don't worry about filling in data in the zombieApprovals mapping, we'll do it in the next chapter.
*/
--------------------------------------------
pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {

  // 1. Define mapping here
  mapping (uint => address) zombieApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to]++;
    ownerZombieCount[_from]--;
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    // 2. Add the require statement here
    require(zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
    // 3. Call _transfer
  }

  function approve(address _approved, uint256 _tokenId) external payable {

  }

}
