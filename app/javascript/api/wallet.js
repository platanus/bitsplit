/* eslint-disable camelcase */
import { authedAxios } from '../helpers';

const depositApi = payload => {
  const { amount, currency } = payload;

  if (!amount || !currency) return Promise.reject('Error');

  return authedAxios.post('/api/v2/deposits/', {
    amount,
    currency,
  });
};
const widthdrawalApi = payload => {
  const { invoice } = payload;

  if (!invoice) return Promise.reject('Error');

  return authedAxios.post('/api/v2/withdrawals', {
    invoice,
  });
};

export { depositApi, widthdrawalApi };
