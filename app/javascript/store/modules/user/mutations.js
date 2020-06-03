import {
  GET_CURRENT_USER,
  SIGNIN_ATTEMPT,
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNOUT,
  SIGNUP_ATTEMPT,
  SIGNUP_FAIL,
  SIGNUP_SUCCESS,
  BUDA_SIGNIN_ATTEMPT,
  BUDA_SIGNIN_FAIL,
  BUDA_SIGNIN_SUCCESS,
  BUDA_SIGNOUT,
  GET_USER_BALANCE_ATTEMPT,
  GET_USER_BALANCE_FAIL,
  GET_USER_BALANCE_SUCCESS,
  SEND_PAYMENT_ATTEMPT,
  SEND_PAYMENT_FAIL,
  SEND_PAYMENT_SUCCESS,
  GET_PAYMENTS_ATTEMPT,
  GET_PAYMENTS_FAIL,
  GET_PAYMENTS_SUCCESS,
  GET_DEBTS_ATTEMPT,
  GET_DEBTS_FAIL,
  GET_DEBTS_SUCCESS,
} from '../../mutation-types';

import { filterSingleDebts, filterGroupDebts } from '../../../helpers';

export default {
  [GET_CURRENT_USER](state, currentUser) {
    state.currentUser = currentUser;
  },
  [SIGNIN_ATTEMPT](state) {
    state.signInLoading = true;
  },
  [SIGNIN_SUCCESS](state, currentUser) {
    state.signInLoading = false;
    state.currentUser = currentUser;
  },
  [SIGNIN_FAIL](state) {
    state.signInLoading = false;
  },
  [SIGNOUT](state) {
    state.currentUser = null;
  },
  [SIGNUP_ATTEMPT](state) {
    state.signUpLoading = true;
  },
  [SIGNUP_SUCCESS](state) {
    state.signUpLoading = false;
  },
  [SIGNUP_FAIL](state) {
    state.signUpLoading = false;
  },
  [BUDA_SIGNIN_ATTEMPT](state) {
    state.budaSignInLoading = true;
  },
  [BUDA_SIGNIN_SUCCESS](state, currentUser) {
    state.budaSignInLoading = false;
    state.currentUser = currentUser;
  },
  [BUDA_SIGNIN_FAIL](state) {
    state.budaSignInLoading = false;
  },
  [BUDA_SIGNOUT](state, currentUser) {
    state.currentUser = currentUser;
  },
  [GET_USER_BALANCE_ATTEMPT](state) {
    state.getBalanceLoading = true;
  },
  [GET_USER_BALANCE_SUCCESS](state, balance) {
    state.getBalanceLoading = false;
    state.userBalanceCLP = parseFloat(balance.CLP.available_amount);
    state.userBalanceBTC = parseFloat(balance.BTC.available_amount);
  },
  [GET_USER_BALANCE_FAIL](state) {
    state.getBalanceLoading = false;
  },
  [SEND_PAYMENT_ATTEMPT](state) {
    state.paymentLoading = true;
  },
  [SEND_PAYMENT_SUCCESS](state, attributes) {
    state.paymentLoading = false;
    state.lastPayment = {
      amount: parseFloat(attributes.amount),
      receiver: attributes.receiver_email,
      date: attributes.created_at,
    };
  },
  [SEND_PAYMENT_FAIL](state) {
    state.paymentLoading = false;
  },
  [GET_PAYMENTS_ATTEMPT](state) {
    state.getPaymentsLoading = true;
  },
  [GET_PAYMENTS_FAIL](state) {
    state.getPaymentsLoading = false;
  },
  [GET_PAYMENTS_SUCCESS](state, payments) {
    state.getPaymentsLoading = false;
    state.paymentsHistory = payments;
  },
  [GET_DEBTS_ATTEMPT](state) {
    state.getDebtsLoading = true;
  },
  [GET_DEBTS_FAIL](state) {
    state.getDebtsLoading = false;
  },
  [GET_DEBTS_SUCCESS](state, user_to_friends, friends_to_user) {
    state.getDebtsLoading = false;
    state.userDebts = {
      user_to_friends: {
        single_user_to_friends: filterSingleDebts(user_to_friends),
        group_user_to_friends: filterGroupDebts(user_to_friends),
      },
      friends_to_user: {
        single_friends_to_user: filterSingleDebts(friends_to_user),
        group_friends_to_user: filterGroupDebts(friends_to_user),
      },
    };
  },
};
