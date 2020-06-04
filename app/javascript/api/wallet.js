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

  return Promise.resolve({
    data: {
      data: {
        response: {
          id: 'f485e58f-8fa9-4e9e-a608-9f78caba3129',
          name: null,
          description: 'N/A',
          created_at: 1589572945,
          status: 'unpaid',
          callback_url: null,
          success_url: 'https://www.opennode.com',
          order_id: 'N/A',
          notes: '',
          currency: 'CLP',
          source_fiat_value: 200,
          fiat_value: 200,
          auto_settle: false,
          notif_email: null,
          lightning_invoice: {
            expires_at: 1589576545,
            payreq:
              'LNBC25940N1P0TAA23PP56MCL7UTKYDM2HUJE47SUQWXX7YRE3DGYJK5WRCPW80LZPWGHPHHQDQ9FCH5ZCQZPG8XT8K4S3682JMX0VNS2G3V62L367GALTAZLX6TTMFDPMJ9K7S0HHGM2MWNZK7Z7YFLVJVWWDF6TX3GQFKFD7N2TXX5S2LZVCCPN2AEQQ89WRDD',
          },
          chain_invoice: {
            address: '3LUvbCKZfAHGQzZM95cDFGeHrJ1ecqtj9F',
          },
          address: '3LUvbCKZfAHGQzZM95cDFGeHrJ1ecqtj9F',
          amount: 2594,
          uri:
            'bitcoin:3LUvbCKZfAHGQzZM95cDFGeHrJ1ecqtj9F?amount=0.00002594&label=N/A&lightning=LNBC25940N1P0TAA23PP56MCL7UTKYDM2HUJE47SUQWXX7YRE3DGYJK5WRCPW80LZPWGHPHHQDQ9FCH5ZCQZPG8XT8K4S3682JMX0VNS2G3V62L367GALTAZLX6TTMFDPMJ9K7S0HHGM2MWNZK7Z7YFLVJVWWDF6TX3GQFKFD7N2TXX5S2LZVCCPN2AEQQ89WRDD',
        },
      },
    },
  });
};
const widthdrawalTestApi = payload => {
  const { invoice } = payload;

  if (!invoice) return Promise.reject('Error');

  return Promise.resolve({
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
      },
    },
  });
};

export { chargeApi, widthdrawalApi, widthdrawalTestApi, chargeTestApi };
