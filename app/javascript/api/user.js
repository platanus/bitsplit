/* eslint-disable camelcase */
import axios from 'axios';
import { authedAxios } from '../helpers';

const loginApi = payload =>
  axios.post(
    '/api/v1/sessions/',
    {
      user: {
        email: payload.email,
        password: payload.password,
      },
    },
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

const logoutApi = () => authedAxios.delete('/api/v1/sessions');

const signUpApi = payload =>
  axios.post(
    '/api/v1/users/',
    {
      email: payload.email,
      password: payload.password,
      password_confirmation: payload.password,
    },
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

const sendRecoveryEmailApi = email => Promise.resolve({ data: email });

const budaSyncApi = payload =>
  authedAxios.patch('/api/v1/users/', {
    password: payload.password,
    api_key: payload.api_key,
    api_secret: payload.api_secret,
  });

const updateUserApi = payload => authedAxios.patch('/api/v1/users/', payload);

const getCurrentUserApi = () => authedAxios.get('/api/v1/users/');

const getQuotationApi = payload =>
  authedAxios.post('/api/v1/quotations/', {
    amount: payload.amount,
  });

const getUserBalanceApi = () => authedAxios.get('/api/v2/balances/');

const sendPaymentApi = payload =>
  authedAxios.post('/api/v2/transfers/', {
    amount: payload.payment_amount,
    receiver_email: payload.receiver_email,
    wallet_origin: payload.wallet_origin,
  });

const getPaymentsApi = () => authedAxios.get('/api/v1/payments/');

const getSplitwiseUrlApi = () =>
  authedAxios.post('/api/v1/splitwise/authentications/');

const getSplitwiseDebtsApi = () => authedAxios.get('/api/v1/splitwise/debts/');

const payOffSplitwiseDebtApi = payload =>
  authedAxios.post('/api/v1/splitwise/debts/', {
    amount_clp: payload.amount_clp,
    group_id: payload.group_id,
    to_user_id: payload.to_user_id,
  });

export {
  loginApi,
  logoutApi,
  signUpApi,
  budaSyncApi,
  getCurrentUserApi,
  getQuotationApi,
  getUserBalanceApi,
  sendPaymentApi,
  getPaymentsApi,
  getSplitwiseUrlApi,
  getSplitwiseDebtsApi,
  updateUserApi,
  sendRecoveryEmailApi,
  payOffSplitwiseDebtApi,
};
