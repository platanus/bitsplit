const user = JSON.parse(localStorage.getItem('currentUser'))

export default {
  currentUser: user, // Si no esta es null
  userLoading: false,
  userBalanceCLP: 0,
  userBalanceBTC: 0,
  quotationCLP: 0,
  quotationBTC: 0,
}