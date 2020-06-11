export default {
  signedIn: state => state.currentUser !== null,
  budaSignedIn: state =>
    state.currentUser.api_key !== '' && state.currentUser.api_key !== null,
  splitwiseSignedIn: state => state.currentUser.picture_url,
  splitwisePaymentChecked: state => state.splitwisePaymentData,
};
