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
        Html = '<!DOCTYPE html> <html> <head> <meta charset="UTF-8" /> <style> html { display: flex; justify-content: center; } </style> </head> <body> <canvas id="canvas" width="460" height="460"></canvas> </body> <script> window.onload = function () { "use strict"; var canvas = document.getElementById("canvas"); var form = document.createElement("form"); var ctx = canvas.getContext("2d"); var w = document.getElementById("canvas").offsetWidth; var h = document.getElementById("canvas").offsetHeight; var terrainImageLoaded = false, houseImageLoaded = false, pokeballImageLoaded = false, playerImageLoaded = false; var objectSizes = 20; var speed = 100; var modifier = 100; var GAME_ACTIVE = false; var IS_NFT_OWNER = false; var score = 0; var playerName = null; if (!playerName) { canvas.style.display = "none"; form.style.display = "flex"; form.style.width = "460px"; form.style.height = "460px"; form.style.border = "1px solid black"; form.style.background = "#71D15B"; form.style.flexDirection = "column"; form.style.alignItems = "center"; form.style.justifyContent = "center"; const input = document.createElement("input"); input.setAttribute("type", "text"); input.setAttribute("placeholder", "Input address"); input.style.textAlign = "center"; input.style.marginBottom = "6px"; const btn = document.createElement("button"); btn.setAttribute("type", "submit"); btn.addEventListener("click", loadMain); btn.style.border = "1px solid black"; btn.style.padding = "8px 12px"; btn.style.background = "#EB3001"; btn.style.cursor = "pointer"; btn.textContent = "Play"; form.appendChild(input); form.appendChild(btn); form.addEventListener("submit", (event) => { event.preventDefault(); fetch("https://mario-nft.onrender.com/results", { method: "POST", headers: { "Content-Type": "application/json", }, body: JSON.stringify({ name: input.value, score: 0, }), }) .then((response) => response.text()) .then((data) => { console.log(JSON.parse(data)); var jsonData = JSON.parse(data); playerName = jsonData.data; console.log("Player name >", playerName); }) .catch((error) => console.error(error)); form.style.display = "none"; canvas.style.display = "block"; }); document.body.appendChild(form); } function loadMain() { canvas.style.display = "block"; form.style.display = "none"; GAME_ACTIVE = true; setTimeout(() => { isNftOwner(playerName); console.log( `User address: ${playerName}. Game available: ${GAME_ACTIVE}. Is owner NFT: ${IS_NFT_OWNER}` ); }, 5000); function isNftOwner(address) { fetch(`https://mario-nft.onrender.com/isOwner?address=${address}`) .then((response) => response.json()) .then((data) => { if (data.ownerItems > 0) { IS_NFT_OWNER = true; } console.log(data.ownerItems); }) .catch((error) => console.error(error)); } var terrainImage = new Image(); terrainImage.onload = function () { terrainImageLoaded = true; assetsLoaded(); }; terrainImage.src = "https://drive.google.com/uc?id=1o9rhnAr2GIilfjxPm4Wdl1BlaVP4Gsj1"; var houseImage = new Image(); houseImage.onload = function () { houseImageLoaded = true; assetsLoaded(); }; houseImage.src = "https://drive.google.com/uc?id=1YO5Mg6IzlskREYSRcr2Ut00JZI49ivnR"; var mainTheme = new Audio( "https://drive.google.com/uc?id=1ljrlJ1UBrH4YnIpxH02jqR_oJeLZhkDv" ); mainTheme.loop = true; mainTheme.volume = 0.5; mainTheme.play(); var pokePick = new Audio( "https://drive.google.com/uc?id=1ULOY_JeGQWJ0SOcxQfBtNQ77e20sWa31" ); pokePick.volume = 0.8; var playerImage = new Image(); playerImage.onload = function () { pokeballImageLoaded = true; assetsLoaded(); }; playerImage.src = "https://drive.google.com/uc?id=1ZsYCAWG7uR2_nZTVsIOOUog4tXFIUsgB"; var pokeballImage = new Image(); pokeballImage.onload = function () { playerImageLoaded = true; assetsLoaded(); }; pokeballImage.src = "https://drive.google.com/uc?id=1XiXaiRlytnRI2ncwnBWyyef79guxI55X"; var pokeball = { x: 0, y: 0, spritePosition: 0, spriteItemDistance: 33, }; pokeball.generatePosition = function () { do { pokeball.x = Math.floor(Math.random() * 20) + 1; pokeball.y = Math.floor(Math.random() * 16) + 4; } while (check_collision(pokeball.x, pokeball.y)); pokeball.spritePosition = Math.floor(Math.random() * 4) + 0; }; var player = { x: Math.round(w / 2 / objectSizes), y: Math.round(h / 2 / objectSizes), currentDirection: "stand", direction: { stand: { x: 0, y: 0, }, "down-1": { x: 17, y: 0, }, "down-2": { x: 34, y: 0, }, "up-1": { x: 125, y: 0, }, "up-2": { x: 142, y: 0, }, "left-1": { x: 69, y: 0, }, "left-2": { x: 87, y: 0, }, "right-1": { x: 160, y: 0, }, "right-2": { x: 178, y: 0, }, }, }; player.move = function (direction) { var hold_player = { x: player.x, y: player.y, }; switch (direction) { case "left": player.x -= speed / modifier; if (player.currentDirection == "stand") { player.currentDirection = "left-1"; } else if (player.currentDirection == "left-1") { player.currentDirection = "left-2"; } else if (player.currentDirection == "left-2") { player.currentDirection = "left-1"; } else { player.currentDirection = "left-1"; } break; case "right": player.x += speed / modifier; if (player.currentDirection == "stand") { player.currentDirection = "right-1"; } else if (player.currentDirection == "right-1") { player.currentDirection = "right-2"; } else if (player.currentDirection == "right-2") { player.currentDirection = "right-1"; } else { player.currentDirection = "right-1"; } break; case "up": player.y -= speed / modifier; if (player.currentDirection == "stand") { player.currentDirection = "up-1"; } else if (player.currentDirection == "up-1") { player.currentDirection = "up-2"; } else if (player.currentDirection == "up-2") { player.currentDirection = "up-1"; } else { player.currentDirection = "up-1"; } break; case "down": player.y += speed / modifier; if (player.currentDirection == "stand") { player.currentDirection = "down-1"; } else if (player.currentDirection == "down-1") { player.currentDirection = "down-2"; } else if (player.currentDirection == "down-2") { player.currentDirection = "down-1"; } else { player.currentDirection = "down-1"; } break; } if (check_collision(player.x, player.y)) { player.x = hold_player.x; player.y = hold_player.y; } if (player.x == pokeball.x && player.y == pokeball.y) { console.log( "found a pokeball of " + pokeball.spritePosition + "! Bravo! " ); pokePick.pause(); pokePick.currentTime = 0; pokePick.play(); score += 1; pokeball.generatePosition(); } update(); }; function update() { ctx.drawImage(terrainImage, 0, 0); ctx.drawImage(houseImage, 80, 60); board(); ctx.drawImage( pokeballImage, pokeball.spritePosition * pokeball.spriteItemDistance, 0, objectSizes, objectSizes, pokeball.x * objectSizes, pokeball.y * objectSizes, objectSizes, objectSizes ); console.log("y:", (player.y * objectSizes) / objectSizes); console.log("x", (player.x * objectSizes) / objectSizes); ctx.drawImage( playerImage, player.direction[player.currentDirection].x, player.direction[player.currentDirection].y, objectSizes - 2, objectSizes, player.x * objectSizes, player.y * objectSizes, objectSizes, objectSizes ); updateResults(); } function check_collision(x, y) { var foundCollision = false; if ( (x > 3 && x < 9 && y == 6) || (x > 4 && x < 9 && (y == 5 || y == 4 || y == 3)) ) { console.log("on house"); foundCollision = true; } if ( x < 1 || x > 20 || y < 2 || y > 20 || (y > 0 && y < 4 && (x == 20 || x == 19)) || (y > 0 && y < 4 && (x == 2 || x == 3)) || (y > 18 && (x == 2 || x == 3)) || (x > 17 && (y == 19 || y == 20)) || (x > 19 && (y == 17 || y == 18)) ) { console.log("lost on the woods"); foundCollision = true; } return foundCollision; } function board() { if (IS_NFT_OWNER === false) { ctx.fillStyle = "rgba(0, 0, 0, 0.5)"; ctx.fillRect(w - 110, h - 70, -280, 30); ctx.font = "12px Arial"; ctx.fillStyle = "#FF5755"; ctx.fillText( "Only NFT owners results count in the leaderboard", w - 380, h - 50 ); } if (score === 0) { ctx.fillStyle = "rgba(0, 0, 0, 0.5)"; ctx.fillRect(w - 100, h - 70, 100, 70); ctx.font = "18px Arial"; ctx.fillStyle = "rgba(255, 255, 255, 1)"; ctx.fillText("SUCCESS", w - 93, h - 40); ctx.font = "18px Arial"; ctx.fillStyle = "rgba(255, 255, 255, 1)"; ctx.fillText("HARVEST", w - 93, h - 20); } else { ctx.fillStyle = "rgba(0, 0, 0, 0.5)"; ctx.fillRect(w - 100, h - 70, 100, 70); ctx.font = "18px Arial"; ctx.fillStyle = "rgba(255, 255, 255, 1)"; ctx.fillText("You Found", w - 93, h - 45); ctx.font = "14px Arial"; ctx.fillStyle = "rgba(255, 255, 255, 1)"; ctx.fillText(score + " poketballs", w - 85, h - 25); } } function updateResults() { if (score % 10 === 0 && score > 0 && GAME_ACTIVE && IS_NFT_OWNER) { fetch("https://mario-nft.onrender.com/results", { method: "POST", headers: { "Content-Type": "application/json", }, body: JSON.stringify({ name: playerName, score: score, }), }) .then((response) => response.text()) .then((data) => { console.log(data); score = 0; }) .catch((error) => console.error(error)); } } function assetsLoaded() { if ( terrainImageLoaded == true && houseImageLoaded == true && pokeballImageLoaded == true && playerImageLoaded == true ) { pokeball.generatePosition(); update(); } } document.onkeydown = function (e) { e = e || window.event; if (e.keyCode == "37") player.move("left"); else if (e.keyCode == "38") player.move("up"); else if (e.keyCode == "39") player.move("right"); else if (e.keyCode == "40") player.move("down"); }; } }; </script> </html>';
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