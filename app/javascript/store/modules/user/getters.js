export default {
  signedIn: state => state.currentUser !== null,
  budaSignedIn: state => state.currentUser.api_key !== '' && state.currentUser.api_key !== null,
};
