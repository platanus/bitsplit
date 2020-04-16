import { changeProfileComp } from '../../action-types'
import { MUTATE_PROFILE_COMPONENT } from '../../mutation-types'

const state = {
  budaProfileComp: '' // Cambia el componente a renderear en la sección Buda
}

const actions = {
  [changeProfileComp]({commit}, payload) {
    commit(MUTATE_PROFILE_COMPONENT, payload)
  }
}

const mutations = {
  [MUTATE_PROFILE_COMPONENT](state, payload) {
    state.budaProfileComp = payload
  }
}

export default alert = {
  namespaced: true,
  state,
  actions,
  mutations
}