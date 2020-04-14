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
  console.log(payload)

  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(
        axios
          .post(
            'http://localhost:3000/api/v1/users/',
            {
              email: payload.email,
              password: payload.password,
              password_confirmation: payload.password
            },
            {
              headers: { 'Content-Type': 'application/json' }
            }
          )
          .then(response => {
            // TODO: Add logger that only logs in development
            console.log(response)
            return response
          })
          .catch(err => {
            console.error(err)
          })
      )
    }, 1000)
  })
}
export { loginApi, logoutApi, signUpApi }
