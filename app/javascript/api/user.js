const loginApi = payload => {
  // TODO add real interaction with backend

  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({
        data: {
          user: {
            authentication_token: 'smnozAAbYnEX2xVRfS5R',
            email: 'example@example.com',
            api_key: 'th3b3stAP1K3Y'
          }
        }
      })
    }, 1000)
  })
}
const logoutApi = payload => {
  // TODO add real interaction with backend

  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({})
    }, 1000)
  })
}

export { loginApi, logoutApi }
