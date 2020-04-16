const user = JSON.parse(localStorage.getItem('currentUser'))

export default {
  currentUser: user, // Si no esta es null
  userLoading: false,
  budaPerfilComp: '' // Cambia el componente a renderear en la sección Buda
}