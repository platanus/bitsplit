import axios from 'axios';
import store from '../store';

const checkAuth = (to, from, next) => {
  if (store.getters['user/signedIn']) {
    next();
  } else {
    next('/');
  }
};

const checkNoAuth = (to, from, next) => {
  if (store.getters['user/signedIn']) {
    next('/home');
  } else {
    next();
  }
};

const checkBudaAuth = (to, from, next) => {
  // Cuando trato de ir a /payments pero aun no estoy sincronizxado con buda
  if (store.getters['user/budaSignedIn']) {
    next();
  } else {
    next('/buda');
  }
};

const mergeDebts = array => {
  const result = array.reduce((r, a) => {
    r[a.group_id] = r[a.group_id] || [];
    r[a.group_id].push(a);

    return r;
  }, Object.create(null));

  return Object.values(result);
};

const filterSingleDebts = array => {
  const result = array ? array.filter(debt => debt.group_id === 0) : null;

  return result;
};

const filterGroupDebts = array => {
  const result = array
    ? mergeDebts(array.filter(debt => debt.group_id > 0))
    : null;

  return result;
};

const authedAxios = axios.create();

authedAxios.interceptors.request.use(
  config => {
    config.headers['X-User-Token'] =
      store.state.user.currentUser.authentication_token;
    config.headers['X-User-Email'] = store.state.user.currentUser.email;
    config.headers['Content-Type'] = 'application/json';

    return config;
  },
  error => Promise.reject(error)
);

export {
  checkAuth,
  checkNoAuth,
  checkBudaAuth,
  filterSingleDebts,
  filterGroupDebts,
  authedAxios,
};
