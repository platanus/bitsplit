/* eslint-disable camelcase */
import { authedAxios } from '../helpers';

const chargeApi = payload => {
  const { amount, currency } = payload;

  if (!amount || !currency) return Promise.reject('Error');

  return authedAxios.post('/api/v2/charges/', {
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

const chargeTestApi = payload => {
  const { amount, currency } = payload;

  if (!amount || !currency) return Promise.reject('Error');

  return setTimeout(
    () => ({
      data: {
        data: {
          response: {
            id: '3f50999e-f21f-4981-b67c-ea9c075be7d6',
            type: 'ln',
            amount: 10,
            reference:
              'lntb100n1pw0fl34pp5p8u6alsp6vr7ngevp82lu6kz7j4ryla0dgpg9es0jq70shs39xzsdqqcqzpgxqyz5vqm5egyvdadnnvrecqdzamwl6guhhvkpja0s9e0vu6g0ay75kegzfnhjykdveagfj8rt9nay0yvu8j94shsvj3ghxu306y2pac02nq85qq7m8tsc',
            fee: 0,
            status: 'pending',
            processed_at: 1559559748,
          },
          // eslint-disable-next-line no-magic-numbers
        },
      },
    }),
    1000
  );
};
const widthdrawalTestApi = payload => {
  const { invoice } = payload;

  if (!invoice) return Promise.reject('Error');

  return setTimeout(
    () => ({
      data: {
        data: {
          response: {
            id: '3f50999e-f21f-4981-b67c-ea9c075be7d6',
            type: 'ln',
            amount: 10,
            reference:
              'lntb100n1pw0fl34pp5p8u6alsp6vr7ngevp82lu6kz7j4ryla0dgpg9es0jq70shs39xzsdqqcqzpgxqyz5vqm5egyvdadnnvrecqdzamwl6guhhvkpja0s9e0vu6g0ay75kegzfnhjykdveagfj8rt9nay0yvu8j94shsvj3ghxu306y2pac02nq85qq7m8tsc',
            fee: 0,
            status: 'pending',
            processed_at: 1559559748,
          },
          // eslint-disable-next-line no-magic-numbers
        },
      },
    }),
    1000
  );
};

export { chargeApi, widthdrawalApi, widthdrawalTestApi, chargeTestApi };
