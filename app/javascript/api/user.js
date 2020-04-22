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

export { loginApi, logoutApi, signUpApi, budaSyncApi, getCurrentUserApi }
