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

const groupDebtsById = (friendsToUser, userToFriends) => {
  const debts = {};
  friendsToUser &&
    friendsToUser.forEach(
      ({ group_id, group_name, from, amount, currency_code }) => {
        if (!debts[group_id]) {
          debts[group_id] = {
            group_id,
            group_name,
            friendsToUser: [],
            userToFriends: [],
          };
        }
        debts[group_id].friendsToUser.push({ ...from, amount, currency_code, type: 1 });
      }
    );
  userToFriends &&
    userToFriends.forEach(
      ({ group_id, group_name, to, amount, currency_code }) => {
        if (!debts[group_id]) {
          debts[group_id] = {
            group_id,
            group_name,
            friendsToUser: [],
            userToFriends: [],
          };
        }
        debts[group_id].userToFriends.push({ ...to, amount, currency_code, type: 0 });
      }
    );
  return debts;
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
  groupDebtsById,
  authedAxios,
};
