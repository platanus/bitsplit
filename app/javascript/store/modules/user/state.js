const user = JSON.parse(localStorage.getItem('currentUser','budaProfileComp'))

export default {
  currentUser: user, // Si no esta es null
  userLoading: false,
  budaProfileComp: '' // Cambia el componente a renderear en la sección Buda
}