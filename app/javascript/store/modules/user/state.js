const user = JSON.parse(localStorage.getItem('currentUser'));

export default {
  currentUser: user, // Si no esta es null
  signInLoading: false,
  signUpLoading: false,
  budaSignInLoading: false,
  getBalanceLoading: false,
  getPaymentsLoading: false,
  getSplitwiseDebtsLoading: false,
  sendPaymentLoading: false,
  userBalanceCLP: 0,
  userBalanceBTC: 0,
  userLastPaymentData: null,
  userPaymentsHistory: [],
  userSplitwiseDebts: [],
};
