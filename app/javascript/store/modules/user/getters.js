export default {
    signedIn: state => {
      return state.currentUser !== null
    },
    budaSignedIn: state => {
      return state.currentUser.api_key !== '' && state.currentUser.api_key !== null
    }
  }