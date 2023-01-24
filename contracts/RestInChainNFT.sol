// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract RestInChainNFT is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public price = 0.001 * (10 ** 18);

    string baseSVGFirstPart = "<svg height='200' width='200' xmlns='http://www.w3.org/2000/svg'><rect fill='black' x='0' y='0' width='200' height='200'></rect><g><svg version='1.0' xmlns='http://www.w3.org/2000/svg' width='19.000000pt' height='25.000000pt' viewBox='0 0 912.000000 1280.000000' preserveAspectRatio='xMidYMid meet'><g transform='translate(0.000000,1280.000000) scale(0.100000,-0.100000)' fill='rgb(216,215,215)' stroke='none'><path d='M4367 12489 c-475 -23 -784 -97 -1127 -269 -420 -210 -856 -594 -1097 -967 -22 -33 -54 -79 -71 -100 -125 -158 -319 -562 -427 -887 -74 -223 -99 -326 -140 -577 -58 -357 -68 -543 -39 -737 54 -363 147 -689 299 -1038 69 -158 195 -405 261 -509 31 -49 107 -181 169 -291 111 -199 275 -465 405 -659 183 -274 689 -1001 754 -1085 l74 -95 -25 -50 c-14 -27 -68 -126 -121 -220 -52 -93 -196 -366 -319 -605 -124 -239 -265 -510 -315 -602 -104 -195 -341 -687 -435 -903 -36 -82 -89 -204 -118 -270 -51 -117 -225 -603 -225 -630 0 -7 58 -84 128 -172 71 -87 153 -192 183 -233 30 -42 111 -150 181 -240 70 -91 191 -248 269 -350 605 -788 601 -784 617 -764 7 11 47 87 87 169 40 83 296 600 570 1150 273 550 580 1167 680 1370 101 204 193 379 205 390 22 20 22 20 43 -9 24 -31 238 -379 322 -521 29 -49 171 -286 315 -525 145 -239 354 -586 465 -770 111 -184 293 -486 405 -670 111 -184 218 -361 237 -392 19 -32 37 -58 41 -58 4 0 20 21 37 48 16 26 119 184 229 352 109 168 300 463 424 655 123 193 291 451 373 575 82 124 149 235 149 245 0 11 -10 36 -21 55 -12 19 -54 109 -94 200 -115 260 -135 301 -296 612 -354 682 -750 1328 -1376 2243 -49 72 -94 144 -100 162 -11 31 -5 42 244 430 141 219 324 504 408 633 178 274 360 567 432 695 79 141 237 461 292 591 181 432 295 943 306 1369 4 155 2 185 -25 339 -113 642 -320 1135 -705 1681 -208 295 -331 435 -490 556 -101 77 -414 283 -522 344 -254 141 -568 252 -848 299 -129 22 -374 46 -447 44 -35 0 -134 -5 -221 -9z m588 -1654 c372 -44 700 -157 1030 -355 128 -77 197 -129 220 -164 13 -20 9 -38 -49 -202 -180 -507 -371 -917 -627 -1346 -126 -210 -477 -739 -699 -1053 -90 -126 -199 -283 -242 -347 -43 -65 -82 -118 -86 -118 -4 1 -124 147 -267 326 -143 180 -316 394 -384 478 -143 175 -171 215 -353 511 -290 471 -491 892 -673 1409 -63 178 -75 222 -67 240 25 56 295 245 488 344 366 186 686 263 1224 296 104 6 354 -4 485 -19z'/></g></svg></g><text x='100' y='85' fill='white' text-anchor='middle' alignment-baseline='central' font-family='Alegreya' font-size='20' font-style='normal'>";
    string baseSVGSecondPart = "</text><text x='100' y='105' fill='rgb(176,170,170)' text-anchor='middle' alignment-baseline='central' font-family='Lato' font-size='12' font-style='normal'>";
    string baseSVGThirdPart = "</text><text x='100' y='130' fill='rgb(216,215,215)' text-anchor='middle' alignment-baseline='central' font-family='Lato' font-size='14' font-style='normal'>";
    string baseSVGFourthPart = "</text><text x='195' y='193' fill='white' text-anchor='end' alignment-baseline='central' font-family='Lato' font-size='8' font-style='bold'>#";
    string baseSVGFifthPart = "</text></svg>";

    mapping(address => uint256[]) private _nftHolders;

    constructor() ERC721 ("RestInChainNFT", "RestInChainNFT") {
        console.log("RestInChainNFT");
    }

    function initPlaceHolderNFTs(string[] memory initNames, string[] memory initYears, string[][] memory initMemories) public onlyOwner {
        for (uint i = 0; i < initNames.length; i++) {
            string memory title = initNames[i];
            string memory subtitle = initYears[i];
            string[] memory descriptions = initMemories[i];
            require(bytes(title).length <= 18, "Name is too long");
            require(bytes(subtitle).length <= 36, "Year is too long");
            require(descriptions.length <= 4, "Memory Text is too long");

            string memory desResult = "";
            string memory plainDes = "";
            for (uint j = 0; j < descriptions.length; j++) {
                require(bytes(descriptions[j]).length <= 30, "Memory Text is too long");
                if (j == 0) {
                    desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='0em'>", descriptions[j], "</tspan>"));
                }
                else {
                    desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='1em'>", descriptions[j], "</tspan>"));
                }
                plainDes = string(abi.encodePacked(plainDes,"||", descriptions[j]));
            }
            uint256 newItemId = _tokenIds.current();
            string memory itemId = Strings.toString(newItemId);
            string memory finalSvg = string(abi.encodePacked(baseSVGFirstPart, title, baseSVGSecondPart, subtitle, baseSVGThirdPart, desResult, baseSVGFourthPart, itemId, baseSVGFifthPart));
            string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "RestInChain-',
                            itemId,
                            '", "description": "RestInChain NFT - Save the name and the memory on Blockchain Forever.", "image": "data:image/svg+xml;base64,',
                            Base64.encode(bytes(finalSvg)),
                            '", "data": {"name": "',
                            title,
                            '", "year": "',
                            subtitle,
                            '", "memory": "',
                            plainDes, 
                            '"}}'
                        )
                    )
                )
            );
            string memory finalTokenUri = string(
                abi.encodePacked("data:application/json;base64,", json)
            );

            _safeMint(msg.sender, newItemId);
            _setTokenURI(newItemId, finalTokenUri);
            _nftHolders[msg.sender].push(newItemId);
            
            _tokenIds.increment();
            sendToYard(newItemId);
        }
    }

    function getYardNFTByPage(uint page, uint offset) public view returns (uint256[] memory) {
        uint maxPageCount = _nftHolders[address(this)].length / offset + (_nftHolders[address(this)].length % offset == 0 ? 0 : 1);
        if (page > maxPageCount || page <= 0) {
            uint256[] memory results = new uint256[](0);
            return results;
        }
        else {
            uint startIndex = (page - 1) * offset;
            uint endIndex = startIndex + offset;
            endIndex = endIndex >= _nftHolders[address(this)].length ? _nftHolders[address(this)].length : endIndex;
            uint256[] memory results = new uint256[](endIndex - startIndex);
            uint count = 0;
            for (uint i = startIndex; i < endIndex; i++) {
                results[count] = _nftHolders[address(this)][_nftHolders[address(this)].length-i-1];
                count++;
            }
            return results;
        }
    }

    function mintSampleNFT(string memory title, string memory subtitle, string[] memory descriptions) public onlyOwner {
        require(bytes(title).length <= 18, "Name is too long");
        require(bytes(subtitle).length <= 36, "Year is too long");
        require(descriptions.length <= 4, "Memory Text is too long");

        string memory desResult = "";
        string memory plainDes = "";
        for (uint i = 0; i < descriptions.length; i++) {
            require(bytes(descriptions[i]).length <= 30, "Memory Text is too long");
            if (i == 0) {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='0em'>", descriptions[i], "</tspan>"));
            }
            else {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='1em'>", descriptions[i], "</tspan>"));
            }
            plainDes = string(abi.encodePacked(plainDes,"||", descriptions[i]));
        }
        
        uint256 newItemId = _tokenIds.current();
        string memory itemId = Strings.toString(newItemId);
        string memory finalSvg = string(abi.encodePacked(baseSVGFirstPart, title, baseSVGSecondPart, subtitle, baseSVGThirdPart, desResult, baseSVGFourthPart, itemId, baseSVGFifthPart));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "RestInChain-',
                        itemId,
                        '", "description": "RestInChain NFT - Save the name and the memory on Blockchain Forever.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "data": {"name": "',
                        title,
                        '", "year": "',
                        subtitle,
                        '", "memory": "',
                        plainDes,
                        '"}}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _nftHolders[msg.sender].push(newItemId);
        
        _tokenIds.increment();
    }

    function buyNFT(string memory title, string memory subtitle, string[] memory descriptions) public payable {
        require(msg.value >= price, "Incorrect Amount");
        require(bytes(title).length <= 18, "Name is too long");
        require(bytes(subtitle).length <= 36, "Year is too long");
        require(descriptions.length <= 4, "Memory Text is too long");

        string memory desResult = "";
        string memory plainDes = "";
        for (uint i = 0; i < descriptions.length; i++) {
            require(bytes(descriptions[i]).length <= 30, "Memory Text is too long");
            if (i == 0) {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='0em'>", descriptions[i], "</tspan>"));
            }
            else {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='1em'>", descriptions[i], "</tspan>"));
            }
            plainDes = string(abi.encodePacked(plainDes,"||", descriptions[i]));
        }
        
        uint256 newItemId = _tokenIds.current();
        string memory itemId = Strings.toString(newItemId);
        string memory finalSvg = string(abi.encodePacked(baseSVGFirstPart, title, baseSVGSecondPart, subtitle, baseSVGThirdPart, desResult, baseSVGFourthPart, itemId, baseSVGFifthPart));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "RestInChain-',
                        itemId,
                        '", "description": "RestInChain NFT - Save the name and the memory on Blockchain Forever.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "data": {"name": "',
                        title,
                        '", "year": "',
                        subtitle,
                        '", "memory": "',
                        plainDes,
                        '"}}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _nftHolders[msg.sender].push(newItemId);
        
        _tokenIds.increment();
    }

    function updateNFTData(uint256 tokenId, string memory title, string memory subtitle, string[] memory descriptions) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        require(bytes(title).length <= 18, "Name is too long");
        require(bytes(subtitle).length <= 36, "Year is too long");
        require(descriptions.length <= 4, "Memory Text is too long");

        string memory desResult = "";
        string memory plainDes = "";
        for (uint i = 0; i < descriptions.length; i++) {
            require(bytes(descriptions[i]).length <= 30, "Memory Text is too long");
            if (i == 0) {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='0em'>", descriptions[i], "</tspan>"));
            }
            else {
                desResult = string(abi.encodePacked(desResult, "<tspan x='100' dy='1em'>", descriptions[i], "</tspan>"));
            }
            plainDes = string(abi.encodePacked(plainDes,"||", descriptions[i]));
        }

        string memory oldItemId = Strings.toString(tokenId);
        string memory finalSvg = string(abi.encodePacked(baseSVGFirstPart, title, baseSVGSecondPart, subtitle, baseSVGThirdPart, desResult, baseSVGFourthPart, oldItemId, baseSVGFifthPart));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "RestInChain-',
                        oldItemId,
                        '", "description": "RestInChain NFT - Save the name and the memory on Blockchain Forever.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '", "data": {"name": "',
                        title,
                        '", "year": "',
                        subtitle,
                        '", "memory": "',
                        plainDes, 
                        '"}}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _setTokenURI(tokenId, finalTokenUri);
    }

    function getAllNFT(address owner) public view returns(uint256[] memory) {
        uint256[] memory tokenIds = _nftHolders[owner];
        return tokenIds;
    }

    function setMinPrice(uint256 newPrice) public onlyOwner {
        price = newPrice;
    }

    function withdrawFund() public onlyOwner {
        address payable owner = payable(owner());
        owner.transfer(address(this).balance);
    }

    function sendToYard(uint256 tokenId) public {
        transferFrom(ERC721.ownerOf(tokenId), address(this), tokenId);
    }
    
    function transferToNewAddress(address to, uint256 tokenId) public {
        safeTransferFrom(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _recalculateIndex(address from, address to, uint256 tokenId) private {
        uint index = 0;
        for (uint i = 0; i < _nftHolders[from].length; i++) {
            if (tokenId == _nftHolders[from][i]) {
                index = i;
            }
        }
        _nftHolders[from][index] = _nftHolders[from][_nftHolders[from].length - 1];
        _nftHolders[from].pop();
        _nftHolders[to].push(tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
        _recalculateIndex(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
        _recalculateIndex(from, to, tokenId);
    }
}