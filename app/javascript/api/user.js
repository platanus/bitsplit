import axios from 'axios'
import { authedAxios } from '../helpers'

const loginApi = payload => {
  return axios.post(
    '/api/v1/sessions/',
    {
      email: payload.email,
      password: payload.password
    },
    {
      headers: { 'Content-Type': 'application/json' }
    }
  )
}

const logoutApi = () => {
  return authedAxios.delete('/api/v1/sessions')
}

const signUpApi = payload => {
  return axios.post(
    '/api/v1/users/',
    {
      email: payload.email,
      password: payload.password,
      password_confirmation: payload.password
    },
    {
      headers: { 'Content-Type': 'application/json' }
    }
  )
}
const budaSyncApi = payload => {
  return authedAxios.patch('/api/v1/users/', {
    password: payload.password,
    api_key: payload.api_key,
    api_secret: payload.api_secret
  })
}
const getCurrentUserApi = () => {
  return authedAxios.get('/api/v1/users/')
}
const getQuotationApi = payload => {
  return authedAxios.post('/api/v1/quotations/', {
    amount: payload.amount
  })
}

const getUserBalanceApi = payload => {
  return authedAxios.get('/api/v1/balances/')
}

const sendPaymentApi = payload => {
  return authedAxios.post('/api/v1/payments/', {
    payment_amount: payload.payment_amount,
    receiver_email: payload.receiver_email
  })
}

export {
  loginApi,
  logoutApi,
  signUpApi,
  budaSyncApi,
  getCurrentUserApi,
  getQuotationApi,
  getUserBalanceApi,
  sendPaymentApi
}
