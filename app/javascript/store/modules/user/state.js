const user = JSON.parse(localStorage.getItem('currentUser'));

export default {
  currentUser: user, // Si no esta es null, lo que devuelve get
  signInLoading: false,
  signOutLoading: false,
  signUpLoading: false,
  budaSignInLoading: false,
  getBalanceLoading: false,
  getPaymentsLoading: false,
  sendPaymentLoading: false,
  userBalanceBudaCLP: 0,
  userBalanceBudaBTC: 0,
  userBalanceBudaBTCCLP: 0,
  userBalanceBitsplitBTC: 0,
  userBalanceBitsplitBTCCLP: 0,
  userLastPaymentData: null,
  userPaymentsHistory: [],
  splitwisePaymentData: null,
};
