import axios from 'axios'

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
const logoutApi = payload => {
  // TODO add real interaction with backend
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({})
    }, 1000)
  })
}
const signUpApi = payload => {
    return axios
    .post(
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
export { loginApi, logoutApi, signUpApi }
