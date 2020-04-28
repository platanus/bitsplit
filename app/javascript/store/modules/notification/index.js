import { firebaseAction } from 'vuexfire'
import { db } from '../../../config/db'

const state = {
  notifications: []
}

const actions = {
  bindNotifications: firebaseAction(({ bindFirebaseRef, rootState }) => {
    const userEmailFirebase = rootState.user.currentUser.email.replace('.', ',')
    const { authentication_token } = rootState.user.currentUser

    return bindFirebaseRef(
      'notifications',
      db
        .ref(`notifications/${userEmailFirebase}`)
        .orderByChild(`${userEmailFirebase}-${authentication_token}`)
    )
  }),
  unbindNotifications: firebaseAction(({ unbindFirebaseRef }) => {
    unbindFirebaseRef('notifications')
  })
}

const getters = {
  unSeenNotifications: state => {
    return state.notifications.filter(d => !d.seen)
  }
}

const mutations = {}

export default {
  namespaced: true,
  state,
  actions,
  getters,
  mutations
}
