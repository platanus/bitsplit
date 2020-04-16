import {
  SIGNIN_ATTEMPT,
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNOUT,
  SIGNUP_ATTEMPT,
  SIGNUP_FAIL,
  SIGNUP_SUCCESS,
  BUDA_SIGNIN_ATTEMPT,
  BUDA_SIGNIN_FAIL,
  BUDA_SIGNIN_SUCCESS,
  BUDA_SIGNOUT,
  MUTATE_PROFILE_COMPONENT
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
  },
  [BUDA_SIGNIN_ATTEMPT](state, currentUser) {
    state.userLoading = true
  },
  [BUDA_SIGNIN_SUCCESS](state, currentUser) {
    state.userLoading = false
    state.currentUser = currentUser
  },
  [BUDA_SIGNIN_FAIL](state) {
    state.userLoading = false
  },
  [BUDA_SIGNOUT](state) {
    state.currentUser = null
  },
  [MUTATE_PROFILE_COMPONENT](state, payload) {
    state.budaProfileComp = payload
  }
}