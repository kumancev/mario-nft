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
        Html = '<!DOCTYPE html> <html> <head> <meta charset="UTF-8" /> <style> html { display: flex; justify-content: center; } </style> </head> <body> <canvas id="canvas" width="460" height="460"></canvas> </body> <script> window.onload = function () { "use strict"; var e = document.getElementById("canvas"), t = document.createElement("form"), n = e.getContext("2d"), r = document.getElementById("canvas").offsetWidth, o = document.getElementById("canvas").offsetHeight, i = !1, l = !1, c = !1, a = !1, s = !1, $ = !1, d = 0, u = null; if (!u) { (e.style.display = "none"), (t.style.display = "flex"), (t.style.width = "460px"), (t.style.height = "460px"), (t.style.border = "1px solid black"), (t.style.background = "#71D15B"), (t.style.flexDirection = "column"), (t.style.alignItems = "center"), (t.style.justifyContent = "center"); let y = document.createElement("input"); y.setAttribute("type", "text"), y.setAttribute("placeholder", "Input address"), (y.style.textAlign = "center"), (y.style.marginBottom = "6px"); let _ = document.createElement("button"); _.setAttribute("type", "submit"), _.addEventListener("click", function y() { (e.style.display = "block"), (t.style.display = "none"), (s = !0), setTimeout(() => { (function e(t) { fetch(`https://mario-nft.onrender.com/isOwner?address=${t}`) .then((e) => e.json()) .then((e) => { e.ownerItems > 0 && ($ = !0), console.log(e.ownerItems); }) .catch((e) => console.error(e)); })(u), console.log( `User address: ${u}. Game available: ${s}. Is owner NFT: ${$}` ); }, 5e3); var _ = new Image(); (_.onload = function () { (i = !0), w(); }), (_.src = "https://drive.google.com/uc?id=1o9rhnAr2GIilfjxPm4Wdl1BlaVP4Gsj1"); var p = new Image(); (p.onload = function () { (l = !0), w(); }), (p.src = "https://drive.google.com/uc?id=1YO5Mg6IzlskREYSRcr2Ut00JZI49ivnR"); var f = new Audio( "https://drive.google.com/uc?id=1ljrlJ1UBrH4YnIpxH02jqR_oJeLZhkDv" ); (f.loop = !0), (f.volume = 0.5), f.play(); var g = new Audio( "https://drive.google.com/uc?id=1ULOY_JeGQWJ0SOcxQfBtNQ77e20sWa31" ); g.volume = 0.8; var x = new Image(); (x.onload = function () { (c = !0), w(); }), (x.src = "https://drive.google.com/uc?id=1ZsYCAWG7uR2_nZTVsIOOUog4tXFIUsgB"); var m = new Image(); (m.onload = function () { (a = !0), w(); }), (m.src = "https://drive.google.com/uc?id=1XiXaiRlytnRI2ncwnBWyyef79guxI55X"); var h = { x: 0, y: 0, spritePosition: 0, spriteItemDistance: 33 }; h.generatePosition = function () { do (h.x = Math.floor(20 * Math.random()) + 1), (h.y = Math.floor(16 * Math.random()) + 4); while (b(h.x, h.y)); h.spritePosition = Math.floor(4 * Math.random()) + 0; }; var v = { x: Math.round(r / 2 / 20), y: Math.round(o / 2 / 20), currentDirection: "stand", direction: { stand: { x: 0, y: 0 }, "down-1": { x: 17, y: 0 }, "down-2": { x: 34, y: 0 }, "up-1": { x: 125, y: 0 }, "up-2": { x: 142, y: 0 }, "left-1": { x: 69, y: 0 }, "left-2": { x: 87, y: 0 }, "right-1": { x: 160, y: 0 }, "right-2": { x: 178, y: 0 }, }, }; function D() { n.drawImage(_, 0, 0), n.drawImage(p, 80, 60), !1 === $ && ((n.fillStyle = "rgba(0, 0, 0, 0.5)"), n.fillRect(r - 110, o - 70, -280, 30), (n.font = "12px Arial"), (n.fillStyle = "#FF5755"), n.fillText( "Only NFT owners results count in the leaderboard", r - 380, o - 50 )), 0 === d ? ((n.fillStyle = "rgba(0, 0, 0, 0.5)"), n.fillRect(r - 100, o - 70, 100, 70), (n.font = "18px Arial"), (n.fillStyle = "rgba(255, 255, 255, 1)"), n.fillText("SUCCESS", r - 93, o - 40), (n.font = "18px Arial"), (n.fillStyle = "rgba(255, 255, 255, 1)"), n.fillText("HARVEST", r - 93, o - 20)) : ((n.fillStyle = "rgba(0, 0, 0, 0.5)"), n.fillRect(r - 100, o - 70, 100, 70), (n.font = "18px Arial"), (n.fillStyle = "rgba(255, 255, 255, 1)"), n.fillText("You Found", r - 93, o - 45), (n.font = "14px Arial"), (n.fillStyle = "rgba(255, 255, 255, 1)"), n.fillText(d + " poketballs", r - 85, o - 25)), n.drawImage( m, h.spritePosition * h.spriteItemDistance, 0, 20, 20, 20 * h.x, 20 * h.y, 20, 20 ), console.log("y:", (20 * v.y) / 20), console.log("x", (20 * v.x) / 20), n.drawImage( x, v.direction[v.currentDirection].x, v.direction[v.currentDirection].y, 18, 20, 20 * v.x, 20 * v.y, 20, 20 ), d % 10 == 0 && d > 0 && s && $ && fetch("https://mario-nft.onrender.com/results", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ name: u, score: d }), }) .then((e) => e.text()) .then((e) => { console.log(e), (d = 0); }) .catch((e) => console.error(e)); } function b(e, t) { var n = !1; return ( ((e > 3 && e < 9 && 6 == t) || (e > 4 && e < 9 && (5 == t || 4 == t || 3 == t))) && (console.log("on house"), (n = !0)), (e < 1 || e > 20 || t < 2 || t > 20 || (t > 0 && t < 4 && (20 == e || 19 == e)) || (t > 0 && t < 4 && (2 == e || 3 == e)) || (t > 18 && (2 == e || 3 == e)) || (e > 17 && (19 == t || 20 == t)) || (e > 19 && (17 == t || 18 == t))) && (console.log("lost on the woods"), (n = !0)), n ); } function w() { !0 == i && !0 == l && !0 == c && !0 == a && (h.generatePosition(), D()); } (v.move = function (e) { var t = { x: v.x, y: v.y }; switch (e) { case "left": (v.x -= 1), "stand" == v.currentDirection ? (v.currentDirection = "left-1") : "left-1" == v.currentDirection ? (v.currentDirection = "left-2") : (v.currentDirection, (v.currentDirection = "left-1")); break; case "right": (v.x += 1), "stand" == v.currentDirection ? (v.currentDirection = "right-1") : "right-1" == v.currentDirection ? (v.currentDirection = "right-2") : (v.currentDirection, (v.currentDirection = "right-1")); break; case "up": (v.y -= 1), "stand" == v.currentDirection ? (v.currentDirection = "up-1") : "up-1" == v.currentDirection ? (v.currentDirection = "up-2") : (v.currentDirection, (v.currentDirection = "up-1")); break; case "down": (v.y += 1), "stand" == v.currentDirection ? (v.currentDirection = "down-1") : "down-1" == v.currentDirection ? (v.currentDirection = "down-2") : (v.currentDirection, (v.currentDirection = "down-1")); } b(v.x, v.y) && ((v.x = t.x), (v.y = t.y)), v.x == h.x && v.y == h.y && (console.log( "found a pokeball of " + h.spritePosition + "! Bravo! " ), g.pause(), (g.currentTime = 0), g.play(), (d += 1), h.generatePosition()), D(); }), (document.onkeydown = function (e) { "37" == (e = e || window.event).keyCode ? v.move("left") : "38" == e.keyCode ? v.move("up") : "39" == e.keyCode ? v.move("right") : "40" == e.keyCode && v.move("down"); }); }), (_.style.border = "1px solid black"), (_.style.padding = "8px 12px"), (_.style.background = "#EB3001"), (_.style.cursor = "pointer"), (_.textContent = "Play"), t.appendChild(y), t.appendChild(_), t.addEventListener("submit", (n) => { n.preventDefault(), fetch("https://mario-nft.onrender.com/results", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ name: y.value, score: 0 }), }) .then((e) => e.json()) .then((e) => { (u = e.data), console.log("Player name >", u); }) .catch((e) => console.error(e)), (t.style.display = "none"), (e.style.display = "block"); }), document.body.appendChild(t); } }; </script> </html>';
        Svg = '<svg xmlns="http://www.w3.org/2000/svg" width="350" height="350" viewBox="0 0 350 350"> <rect width="350" height="350" fill="#7FDE2B" /> <rect x="150" y="150" width="50" height="50" fill="red" /> <rect x="200" y="150" width="50" height="50" fill="red" /> <rect x="150" y="200" width="50" height="50" fill="red" /> <rect x="200" y="200" width="50" height="50" fill="red" /> </svg>';
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