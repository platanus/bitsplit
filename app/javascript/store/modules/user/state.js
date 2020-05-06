const user = JSON.parse(localStorage.getItem('currentUser'))

export default {
  currentUser: user, // Si no esta es null
  signInLoading: false,
  signUpLoading: false,
  budaSignInLoading: false,
  paymentLoading: false,
  userBalanceCLP: 0,
  userBalanceBTC: 0,
  lastPayment: null,
  paymentsHistory: []
}