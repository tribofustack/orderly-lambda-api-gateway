import axios from 'axios'
import jwt  from 'jsonwebtoken'

const CONSUMER = `orderly`
const AUTH_URL = `http://localhost/kong/config`
exports.handler = async (_, res) => {
    try {
        const url = `${AUTH_URL}/consumers/${CONSUMER}/jwt`
        const { data } = await axios.get(url, {})

        const key = data.data[0].key        
        const secret = data.data[0].secret

        const token = jwt.sign({}, secret, { keyid: key, expiresIn: "1d"  })

        res.status(200).json({token, secret})
    } catch(error) {
        return res.status(500).json(error)
    }   
}
