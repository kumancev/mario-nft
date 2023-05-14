import { expect, assert } from 'chai'
import { ethers } from 'hardhat'
import { MarioNFT } from '../typechain-types'

describe('NFT contract', function () {
  let marioNFT: MarioNFT

  this.beforeAll(async function () {
    const MarioNFT = await ethers.getContractFactory('MarioNFT')
    marioNFT = await MarioNFT.deploy()
  })

  it('should set sale status active', async function () {
    await marioNFT.setSaleStatus(true)
    expect(await marioNFT.saleIsActive()).to.equal(true)
  })

  it('mint', async function () {
    await marioNFT.mint()
  })

  it('get metadata', async function () {
    console.log(await marioNFT.tokenURI(1))
  })
})
