const axios = require('axios');
const jwt = require('jsonwebtoken');

const { isValidCPF } = require('./utils/cpf');

const { CONSUMER, AUTH_URL } = process.env;

exports.handler = async (req, res) => {
  try {
    if (!CONSUMER || !AUTH_URL)
      throw new Error('Missing environment configuration.');

    const { cpf } = req.body;
    const isCPFValid = isValidCPF(cpf);

    if (cpf && !isCPFValid)
      return res.status(400).json({ error: 'Invalid CPF.' });

    const url = `${AUTH_URL}/consumers/${CONSUMER}/jwt`;
    const { data: response } = await axios.get(url);
    const [{ key, secret }] = response.data;

    const payload = { isCPFValid };
    const token = jwt.sign(payload, secret, { keyid: key, expiresIn: '1d' });

    return res.status(200).json({ token });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Internal server error.' });
  }
};
