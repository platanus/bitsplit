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
const budaSyncApi = payload =>
  authedAxios.patch('/api/v1/users/', {
    password: payload.password,
    api_key: payload.api_key,
    api_secret: payload.api_secret,
  });

const getCurrentUserApi = () => authedAxios.get('/api/v1/users/');

const getQuotationApi = payload =>
  authedAxios.post('/api/v1/quotations/', {
    amount: payload.amount,
  });

const getUserBalanceApi = () => authedAxios.get('/api/v1/balances/');

const sendPaymentApi = payload =>
  authedAxios.post('/api/v1/payments/', {
    payment_amount: payload.payment_amount,
    receiver_email: payload.receiver_email,
  });

const splitwiseUrlConnectionApi = () =>
  authedAxios.post('/api/v1/splitwise/authentications/');

const getDebtsApi = () => authedAxios.get('/api/v1/splitwise/debts/');

export {
  loginApi,
  logoutApi,
  signUpApi,
  budaSyncApi,
  getCurrentUserApi,
  getQuotationApi,
  getUserBalanceApi,
  sendPaymentApi,
  splitwiseUrlConnectionApi,
  getDebtsApi,
};
