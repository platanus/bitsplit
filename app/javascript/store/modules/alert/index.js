import { success_alert, error_alert, clear_alert } from '../../action-types'
import { SUCCESS_ALERT, ERROR_ALERT, CLEAR_ALERT } from '../../mutation-types'

const state = {
  type: null,
  message: null
}

const actions = {
  [success_alert]({ commit }, message) {
    commit(SUCCESS_ALERT, message)
    setTimeout(() => {
      commit(CLEAR_ALERT)
    }, 4000)
  },
  [error_alert]({ commit }, message) {
    commit(ERROR_ALERT, message)
    setTimeout(() => {
      commit(CLEAR_ALERT)
    }, 4000)
  }
}

const mutations = {
  [SUCCESS_ALERT](state, message) {
    state.type = 'success'
    state.message = message
  },
  [ERROR_ALERT](state, message) {
    state.type = 'error'
    state.message = message
  },
  [CLEAR_ALERT](state) {
    state.type = null
    state.message = null
  }
}

export default alert = {
  namespaced: true,
  state,
  actions,
  mutations
}
