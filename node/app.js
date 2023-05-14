const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const mongoose = require('mongoose')
const Web3 = require('web3')
const { contractAddress, contractABI } = require('./abi/marioNFT')
require('dotenv').config()

const mongoUrl = process.env.DB_URL

const app = express()

app.use(cors())
app.use(bodyParser.json())

mongoose.connect(mongoUrl, { useNewUrlParser: true, useUnifiedTopology: true })
const database = mongoose.connection

database.on('error', (error) => {
  console.log(error)
})

database.once('open', () => {
  console.log('Database Connected')
})

const playerResultSchema = new mongoose.Schema({
  name: String,
  score: Number,
})

const PlayerResult = mongoose.model('PlayerResult', playerResultSchema)

app.post('/results', async (req, res) => {
  const { name, score } = req.body
  try {
    let playerResult = await PlayerResult.findOne({ name })
    if (playerResult) {
      playerResult.score += score
    } else {
      playerResult = new PlayerResult({ name, score })
    }
    await playerResult.save()
    res.status(200).send('Result updated/saved successfully')
  } catch (err) {
    console.error(err)
    res.status(500).send('Error updating/saving result')
  }
})

app.get('/results', async (req, res) => {
  try {
    const playerResults = await PlayerResult.find()
    res.status(200).send(playerResults)
  } catch (err) {
    console.error(err)
    res.status(500).send('Error fetching results')
  }
})

app.get('/isOwner', async (req, res) => {
  try {
    const { address } = req.query
    const web3 = new Web3(
      new Web3.providers.HttpProvider(
        'https://data-seed-prebsc-1-s1.binance.org:8545/'
      )
    )
    const contract = new web3.eth.Contract(contractABI, contractAddress)
    let result = await contract.methods.balanceOf(address).call()

    res.json({ ownerItems: result })
  } catch (error) {
    res.status(500).json({ message: error.message })
  }
})

app.listen(3000, () => {
  console.log('Server listening on port 3000')
})
