import { useEffect, useState } from 'react'
import axios from 'axios'

interface Result {
  name: string
  score: number
  __v: number
  _id: string
}

function App() {
  const [results, setResults] = useState<Array<Result> | undefined>([])

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get(
          'https://mario-nft.onrender.com/results'
        )
        setResults(response.data)
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    }

    fetchData()

    const interval = setInterval(fetchData, 300000) // Fetch data every 5 min

    return () => {
      clearInterval(interval)
    }
  }, [])

  console.log(results)

  return (
    <div className="wrapper">
      <div className="link">
        <p>
          <a
            href="https://testnets.opensea.io/collection/marionft-3"
            target="_blank"
          >
            See collection on OpenSea
          </a>
        </p>
      </div>
      <div className="main">
        <h1>Mario NFT</h1>
        <h4>Leaderboard</h4>
        <div className="board">
          {results?.map((result) => (
            <div key={result._id} className="player">
              <p>{result.name}:</p>
              <p className="score">{result.score}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

export default App
