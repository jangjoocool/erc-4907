// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import './lib/ERC4907URIStorage.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RentalNFT is ERC4907URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenTracker;

    constructor(string memory name_, string memory symbol_) ERC4907(name_, symbol_) {}

    function mint(address to, string memory tokenURI) public {
        uint256 id = _tokenTracker.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);
        _tokenTracker.increment();
    }

    function burn(uint256 tokenId) public {
        require(_msgSender() == ownerOf(tokenId), "sender is not the owner");
        require(userOf(tokenId) != address(0), "token has a user");
        _burn(tokenId);
    }

    function setUser(uint256 tokenId, address user, uint64 expires) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId),"ERC721: transfer caller is not owner nor approved");
        require(userOf(tokenId) == address(0), "token has a user");
        UserInfo storage info =  _users[tokenId];
        info.user = user;
        info.expires = expires;
        emit UpdateUser(tokenId,user,expires);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        require(userOf(tokenId) == address(0), "token has a user");
    }

}