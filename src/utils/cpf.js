/**
 * Validates a Brazilian CPF number.
 * @param {string} cpf The CPF number as a string.
 * @return {boolean} True if the CPF is valid, false otherwise.
 */
export const isValidCPF = cpf => {
  if (!/^\d{11}$/.test(cpf) || /^(\d)\1{10}$/.test(cpf)) return false;

  return Array.from(
    { length: 2 },
    (_, i) =>
      (cpf
        .substring(0, 9 + i)
        .split('')
        .reduce(
          (acc, value, index, array) =>
            acc + parseInt(value, 10) * (array.length + 1 - index),
          0,
        ) %
        11) %
      10,
  ).every((digit, index) => digit === parseInt(cpf[9 + index], 10));
};
