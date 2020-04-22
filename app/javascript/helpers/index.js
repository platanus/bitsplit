import store from '../store'
import axios from 'axios'

const checkAuth = (to, from, next) => {
  if (!store.getters['user/signedIn']) {
    next('/')
  } else {
    next()
  }
}

const checkNoAuth = (to, from, next) => {
  if (store.getters['user/signedIn']) {
    next('/home')
  } else {
    next()
  }
}

const authedAxios = axios.create()

authedAxios.interceptors.request.use(
  config => {
    config.headers['X-User-Token'] =
      store.state.user.currentUser.authentication_token
    config.headers['X-User-Email'] = store.state.user.currentUser.email
    config.headers['Content-Type'] = 'application/json'

    return config
  },
  error => Promise.reject(error)
)

export { checkAuth, checkNoAuth, authedAxios }
