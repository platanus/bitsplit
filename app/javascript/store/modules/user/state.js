const user = JSON.parse(localStorage.getItem('currentUser'))

export default {
  currentUser: user, // Si no esta es null
  userLoading: false,
  userBalanceCLP: 0,
  userBalanceBTC: 0
}