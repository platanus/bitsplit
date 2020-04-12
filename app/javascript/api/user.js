import axios from 'axios'

const loginApi = payload => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(
        axios
          .post(
            'http://localhost:3000/api/v1/sessions/',
            {
              email: payload.email,
              password: payload.password
            },
            {
              headers: { 'Content-Type': 'application/json' }
            }
          )
          .then(response => {
<<<<<<< HEAD
            // TODO: Add logger that only logs in development
=======
            // TODO add real interaction with backend
>>>>>>> [web]: fix: add TODO
            console.log(response)
            return response
          })
          .catch(e => {
            console.error(e)
          })
      )
    }, 1000)
  })
}
const logoutApi = payload => {
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
<<<<<<< HEAD
            console.error(err)
=======
            console.log(err)
>>>>>>> [web]: fix: add TODO
          })
      )
    }, 1000)
  })
}
export { loginApi, logoutApi, signUpApi }
