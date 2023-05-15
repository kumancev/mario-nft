# Mario onChain NFT
Collection: https://testnets.opensea.io/collection/marionft-3
Contract: https://testnet.bscscan.com/address/0x2B80b204733F86abFe5277217DdA01bd23AC76f7#code

# Задумка
Юзер минтит nft => ему открывается возможность играть в игру с сохранением его результата в таблице лидеров (Отдельный сайт где можно отслеживать список лучших игроков).

Весь код для этой логики есть.

Но к сожалению ни cookie ни localstorage после кодировки в base64 не поддерживаются. По итогу сделал форму, но как оказалось view frame на opensea ее тоже не поддерживает, так что юзеру прийдется отдельно открывать вкладку с игрой.
