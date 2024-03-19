/**
 * Validates a Brazilian CPF number.
 * @param {string} cpf The CPF number as a string.
 * @return {boolean} True if the CPF is valid, false otherwise.
 */
module.exports = isValidCPF = cpf => {
  if (!/^\d{11}$/.test(cpf) || /^(\d)\1{10}$/.test(cpf)) return false;

  const calculateCheckDigit = (cpf, factor) =>
    ((cpf
      .substring(0, factor - 1)
      .split('')
      .reduce(
        (sum, currentDigit, index) =>
          sum + parseInt(currentDigit, 10) * (factor - index),
        0,
      ) *
      10) %
      11) %
    10;

  return [10, 11].every(
    factor =>
      calculateCheckDigit(cpf, factor) === parseInt(cpf[factor - 1], 10),
  );
};
