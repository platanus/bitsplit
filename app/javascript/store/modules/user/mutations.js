import {
    SIGNIN_ATTEMPT,
    SIGNIN_FAIL,
    SIGNIN_SUCCESS,
    SIGNOUT,
    SIGNUP_ATTEMPT,
    SIGNUP_FAIL,
    SIGNUP_SUCCESS
  } from '../../mutation-types'
  
  export default {
    [SIGNIN_ATTEMPT](state, currentUser) {
      state.userLoading = true
    },
    [SIGNIN_SUCCESS](state, currentUser) {
      state.userLoading = false
      state.currentUser = currentUser
    },
    [SIGNIN_FAIL](state) {
      state.userLoading = false
    },
    [SIGNOUT](state) {
      state.currentUser = null
    },
    [SIGNUP_ATTEMPT](state) {
      state.userLoading = true
    },
    [SIGNUP_SUCCESS](state, currentUser) {
      state.userLoading = false
      state.currentUser = currentUser
    },
    [SIGNUP_FAIL](state) {
      state.userLoading = false
    }
  }