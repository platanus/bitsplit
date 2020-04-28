import { firebaseAction } from 'vuexfire'
import { db } from '../../../config/db'

const state = {
  notifications: []
}

const actions = {
  bindNotifications: firebaseAction(({ bindFirebaseRef, rootState }) => {
    const userEmail = rootState.user.currentUser.email.replace('.', ',')

    return bindFirebaseRef(
      'notifications',
      db.ref(`notifications/${userEmail}`).orderByKey()
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
