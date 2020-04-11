import {
  SIGNIN_ATTEMPT,
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNOUT
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
  }
}
