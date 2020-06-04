const user = JSON.parse(localStorage.getItem('currentUser'));

export default {
  currentUser: user, // Si no esta es null
  signInLoading: false,
  signUpLoading: false,
  budaSignInLoading: false,
  getBalanceLoading: false,
  getPaymentsLoading: false,
  sendPaymentLoading: false,
  userBudaBalance: {},
  userLastPaymentData: null,
  userPaymentsHistory: [],
};
