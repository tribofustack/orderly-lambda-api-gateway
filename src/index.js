const axios = require('axios');
const jwt = require('jsonwebtoken');

const { CONSUMER, AUTH_URL } = process.env;

exports.handler = async (_, res) => {
  try {
    if (!CONSUMER || !AUTH_URL)
      throw new Error('Please check your environment configuration.');

    const url = `${AUTH_URL}/consumers/${CONSUMER}/jwt`;
    const { data: response } = await axios.get(url, {});

    const [{ key, secret }] = response.data;
    const token = jwt.sign({}, secret, { keyid: key, expiresIn: '1d' });

    return res.status(200).json({ token });
  } catch (error) {
    return res.status(500).json(error);
  }
};
