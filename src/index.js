import axios from 'axios';
import jwt from 'jsonwebtoken';

const CONSUMER = 'orderly';
const AUTH_URL = `http://${process.env.LOAD_BALANCER_IP_ADDRESS}/kong/config`;

exports.handler = async (_, res) => {
  try {
    const url = `${AUTH_URL}/consumers/${CONSUMER}/jwt`;
    const { data } = await axios.get(url, {});

    const [{ key, secret }] = data.data;
    const token = jwt.sign({}, secret, { keyid: key, expiresIn: '1d' });

    return res.status(200).json({ token });
  } catch (error) {
    return res.status(500).json(error);
  }
};
