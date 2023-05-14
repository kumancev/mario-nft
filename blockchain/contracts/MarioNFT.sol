// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);
        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)
            for {
                let i := 0
            } lt(i, len) {
            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)
                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)
                mstore(resultPtr, out)
                resultPtr := add(resultPtr, 4)
            }
            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
            mstore(result, encodedLen)
        }
        return string(result);
    }
}

contract MarioNFT is ERC721, Ownable {
    using Strings for uint256;

    // =================================
	// Storage
	// =================================

    uint256 public constant maxSupply = 1000;
    uint256 public numMinted;  

    bool public saleIsActive;

    // =================================
	// Metadata
	// =================================

    function generateHTMLandSVG() internal pure returns (string memory Html, string memory Svg) {
        Html = '<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8" /> <style> html { display: flex; justify-content: center; } </style> </head> <body> <canvas id="canvas" width="460" height="460"></canvas> </body> <script> window.onload=function(){"use strict";function g(){r.drawImage(p,0,0);r.drawImage(c,80,60);rt();r.drawImage(v,i.spritePosition*i.spriteItemDistance,0,t,t,i.x*t,i.y*t,t,t);console.log("y:",n.y*t/t);console.log("x",n.x*t/t);r.drawImage(a,n.direction[n.currentDirection].x,n.direction[n.currentDirection].y,t-2,t,n.x*t,n.y*t,t,t);ut()}function nt(n,t){var i=!1;return(n>3&&n<9&&t==6||n>4&&n<9&&(t==5||t==4||t==3))&&(console.log("on house"),i=!0),(n<1||n>20||t<2||t>20||t>0&&t<4&&(n==20||n==19)||t>0&&t<4&&(n==2||n==3)||t>18&&(n==2||n==3)||n>17&&(t==19||t==20)||n>19&&(t==17||t==18))&&(console.log("lost on the woods"),i=!0),i}function rt(){r.fillStyle="rgba(0, 0, 0, 0.5)";r.fillRect(f-100,e-70,100,70);r.font="18px Arial";r.fillStyle="rgba(255, 255, 255, 1)";r.fillText("You Found",f-93,e-45);r.font="14px Arial";r.fillStyle="rgba(255, 255, 255, 1)";r.fillText(h+" poketballs",f-85,e-25)}function ut(){h%10==0&&fetch("http://localhost:3000/results",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({name:it,score:h})}).then(n=>n.text()).then(n=>{console.log(n)}).catch(n=>console.error(n))}function y(){w==!0&&b==!0&&k==!0&&d==!0&&(i.generatePosition(),g())}var tt=document.getElementById("canvas"),r=tt.getContext("2d"),f=document.getElementById("canvas").offsetWidth,e=document.getElementById("canvas").offsetHeight,w=!1,b=!1,k=!1,d=!1,t=20,o=100,s=100,h=0,it=`Mario_${Math.floor(Math.random()*9e4)+1e4}`,p=new Image,c,l,u,a,v,i,n;p.onload=function(){w=!0;y()};p.src="https://drive.google.com/uc?id=1o9rhnAr2GIilfjxPm4Wdl1BlaVP4Gsj1";c=new Image;c.onload=function(){b=!0;y()};c.src="https://drive.google.com/uc?id=1YO5Mg6IzlskREYSRcr2Ut00JZI49ivnR";l=new Audio("https://drive.google.com/uc?id=1ljrlJ1UBrH4YnIpxH02jqR_oJeLZhkDv");l.loop=!0;l.volume=.5;l.play();u=new Audio("https://drive.google.com/uc?id=1ULOY_JeGQWJ0SOcxQfBtNQ77e20sWa31");u.volume=.8;a=new Image;a.onload=function(){k=!0;y()};a.src="https://drive.google.com/uc?id=1ZsYCAWG7uR2_nZTVsIOOUog4tXFIUsgB";v=new Image;v.onload=function(){d=!0;y()};v.src="https://drive.google.com/uc?id=1XiXaiRlytnRI2ncwnBWyyef79guxI55X";i={x:0,y:0,spritePosition:0,spriteItemDistance:33};i.generatePosition=function(){do i.x=Math.floor(Math.random()*20)+1,i.y=Math.floor(Math.random()*16)+4;while(nt(i.x,i.y));i.spritePosition=Math.floor(Math.random()*4)+0};n={x:Math.round(f/2/t),y:Math.round(e/2/t),currentDirection:"stand",direction:{stand:{x:0,y:0},"down-1":{x:17,y:0},"down-2":{x:34,y:0},"up-1":{x:125,y:0},"up-2":{x:142,y:0},"left-1":{x:69,y:0},"left-2":{x:87,y:0},"right-1":{x:160,y:0},"right-2":{x:178,y:0}}};n.move=function(t){var r={x:n.x,y:n.y};switch(t){case"left":n.x-=o/s;n.currentDirection=n.currentDirection=="stand"?"left-1":n.currentDirection=="left-1"?"left-2":n.currentDirection=="left-2"?"left-1":"left-1";break;case"right":n.x+=o/s;n.currentDirection=n.currentDirection=="stand"?"right-1":n.currentDirection=="right-1"?"right-2":n.currentDirection=="right-2"?"right-1":"right-1";break;case"up":n.y-=o/s;n.currentDirection=n.currentDirection=="stand"?"up-1":n.currentDirection=="up-1"?"up-2":n.currentDirection=="up-2"?"up-1":"up-1";break;case"down":n.y+=o/s;n.currentDirection=n.currentDirection=="stand"?"down-1":n.currentDirection=="down-1"?"down-2":n.currentDirection=="down-2"?"down-1":"down-1"}nt(n.x,n.y)&&(n.x=r.x,n.y=r.y);n.x==i.x&&n.y==i.y&&(console.log("found a pokeball of "+i.spritePosition+"! Bravo! "),u.pause(),u.currentTime=0,u.play(),h+=1,i.generatePosition());g()};document.onkeydown=function(t){t=t||window.event;t.keyCode=="37"?n.move("left"):t.keyCode=="38"?n.move("up"):t.keyCode=="39"?n.move("right"):t.keyCode=="40"&&n.move("down")}}; </script> </html>';
        Svg = '<svg xmlns="http://www.w3.org/2000/svg" width="350" height="350"> <rect x="125" y="125" width="100" height="100" style="fill:rgb(0,0,0)" /> </svg>';
    }

    function toString(bytes memory data) internal pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function htmlToImageURI(string memory html) internal pure returns (string memory) {
        string memory baseURL = "data:text/html;base64,";
        string memory htmlBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(html))));
        return string(abi.encodePacked(baseURL,htmlBase64Encoded));
    }

    function svgToImageURI(string memory svg) internal pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgBase64Encoded));
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        (string memory html, string memory svg) = generateHTMLandSVG();

        string memory imageURIhtml = htmlToImageURI(html);
        string memory imageURIsvg = svgToImageURI(svg);

        return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "MARIO | ", uint2str(tokenId),"",
                                '", "description":"", "attributes":"", "image":"', imageURIsvg,'", "animation_url":"', imageURIhtml,'"}'
                            )
                        )
                    )
                )
            );
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // =================================
	// Mint
	// =================================

    function mint() public payable {
        require(saleIsActive, "Sale must be active to mint");
        require(numMinted < maxSupply, "Sale has already ended");

        numMinted += 1;
        _safeMint(_msgSender(), numMinted);
    }

    // =================================
	// Owner functions
	// =================================

    function setSaleStatus(bool state) public onlyOwner {
        saleIsActive = state;
    }

    // =================================
	// Constructor
	// =================================
    
    constructor() ERC721("MarioNFT", "MARIO") {}

}