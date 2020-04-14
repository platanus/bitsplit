const user = JSON.parse(localStorage.getItem('currentUser'))

export default {
  currentUser: user, // Si no esta es null
  userLoading: false,
  token: null,
  buda: '',
  api_key: '',
  authToken: ''
}