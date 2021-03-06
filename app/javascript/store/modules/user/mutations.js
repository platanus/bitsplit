import {
  GET_CURRENT_USER,
  SIGNIN_ATTEMPT,
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNOUT_ATTEMPT,
  SIGNOUT_SUCCESS,
  SIGNOUT_FAIL,
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
  GET_DEBTS_SUCCESS,
  SET_SPLITWISE_PAYMENT_DATA,
  SEND_SPLITWISE_PAYMENT_ATTEMPT,
  SEND_SPLITWISE_PAYMENT_FAIL,
  SEND_SPLITWISE_PAYMENT_SUCCESS,
} from '../../mutation-types';

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
  [SIGNOUT_ATTEMPT](state) {
    state.signOutLoading = true;
  },
  [SIGNOUT_SUCCESS](state) {
    state.signOutLoading = false;
    state.currentUser = null;
  },
  [SIGNOUT_FAIL](state) {
    state.signOutLoading = false;
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
    state.userBalanceBudaCLP = parseFloat(balance.buda.CLP.available_amount);
    state.userBalanceBudaBTC = parseFloat(balance.buda.BTC.available_amount);
    state.userBalanceBudaBTCCLP = parseInt(
      balance.buda.BTC_CLP.available_amount,
      10
    );
    state.userBalanceBitsplitBTC = parseFloat(balance.bitsplit.BTC.amount);
    state.userBalanceBitsplitBTCCLP = parseInt(
      balance.bitsplit.BTC_CLP.amount,
      10
    );
  },
  [GET_USER_BALANCE_FAIL](state) {
    state.getBalanceLoading = false;
  },
  [SEND_PAYMENT_ATTEMPT](state) {
    state.sendPaymentLoading = true;
  },
  [SEND_PAYMENT_SUCCESS](state, { data }) {
    state.sendPaymentLoading = false;
    state.userLastPaymentData = data;
  },
  [SEND_PAYMENT_FAIL](state) {
    state.sendPaymentLoading = false;
  },
  [GET_PAYMENTS_ATTEMPT](state) {
    state.getPaymentsLoading = true;
  },
  [GET_PAYMENTS_FAIL](state) {
    state.getPaymentsLoading = false;
  },
  [GET_PAYMENTS_SUCCESS](state, payments) {
    state.getPaymentsLoading = false;
    state.userPaymentsHistory = payments;
  },
  [GET_DEBTS_SUCCESS](state, debts) {
    state.userDebts = debts;
  },
  [SET_SPLITWISE_PAYMENT_DATA](state, data) {
    state.splitwisePaymentData = data;
  },
  [SEND_SPLITWISE_PAYMENT_ATTEMPT](state) {
    state.sendPaymentLoading = true;
  },
  [SEND_SPLITWISE_PAYMENT_SUCCESS](state, { data }) {
    state.sendPaymentLoading = false;
    state.userLastPaymentData = data;
  },
  [SEND_SPLITWISE_PAYMENT_FAIL](state) {
    state.sendPaymentLoading = false;
  },
};
