// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Marketplace {

    mapping(uint => uint) valores;
    IERC721 achievements;
    IERC20 moneda;

    constructor(address contratoMoneda, address contratoAchievement) {
        achievements = IERC721(contratoAchievement);
        moneda = IERC20(contratoMoneda);
    }

    function publicar(uint tokenId, uint valor) public {
        require(valores[tokenId] == 0);
        require(valor > 0);
        require(achievements.getApproved(tokenId) == address(this));

        valores[tokenId] = valor;
    }

    function comprar(uint tokenId) public {
        require(valores[tokenId] != 0);
        require(moneda.allowance(msg.sender, address(this)) >= valores[tokenId]);
        require(achievements.getApproved(tokenId) == address(this));

        moneda.transferFrom(msg.sender, achievements.ownerOf(tokenId), valores[tokenId]);
        achievements.safeTransferFrom(achievements.ownerOf(tokenId), msg.sender, tokenId);
        valores[tokenId] = 0;
    }

}