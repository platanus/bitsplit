import {
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
  GET_PAYMENTS_SUCCESS
} from '../../mutation-types'

export default {
  [SIGNIN_ATTEMPT](state, currentUser) {
    state.signInLoading = true
  },
  [SIGNIN_SUCCESS](state, currentUser) {
    state.signInLoading = false
    state.currentUser = currentUser
  },
  [SIGNIN_FAIL](state) {
    state.signInLoading = false
  },
  [SIGNOUT](state) {
    state.currentUser = null
  },
  [SIGNUP_ATTEMPT](state) {
    state.signUpLoading = true
  },
  [SIGNUP_SUCCESS](state, currentUser) {
    state.signUpLoading = false
    state.currentUser = currentUser
  },
  [SIGNUP_FAIL](state) {
    state.signUpLoading = false
  },
  [BUDA_SIGNIN_ATTEMPT](state, currentUser) {
    // TODO
  },
  [BUDA_SIGNIN_SUCCESS](state, currentUser) {
    state.currentUser = currentUser
  },
  [BUDA_SIGNIN_FAIL](state) {
    // TODO
  },
  [BUDA_SIGNOUT](state) {
    // TODO
  },
  [GET_USER_BALANCE_ATTEMPT](state) {
    // TODO
  },
  [GET_USER_BALANCE_SUCCESS](state, balance) {
    state.userBalanceCLP = parseFloat(balance.CLP.available_amount)
    state.userBalanceBTC = parseFloat(balance.BTC.available_amount)
  },
  [GET_USER_BALANCE_FAIL](state) {
    // TODO
  },
  [SEND_PAYMENT_ATTEMPT](state) {
    // TODO
  },
  [SEND_PAYMENT_SUCCESS](state, attributes) {
    state.lastPayment = { amount: parseFloat(attributes.amount), 
                          receiver: attributes.receiver_email, 
                          date: attributes.created_at 
    }
  },
  [SEND_PAYMENT_FAIL](state) {
    // TODO
  },
  [GET_PAYMENTS_SUCCESS](state, payments){
    state.paymentsHistory = payments
  }
}
