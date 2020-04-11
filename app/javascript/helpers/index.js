import store from '../store/index'

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

export { checkAuth, checkNoAuth }
