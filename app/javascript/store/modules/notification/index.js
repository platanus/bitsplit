import { firebaseAction } from 'vuexfire'
import { db } from '../../../config/db'

import { markAsSeenApi } from '../../../api/notifications'

console.log(firebaseAction)
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
  }),
  markAsSeen: firebaseAction(({}, notificationToken) => {
    return markAsSeenApi(notificationToken)
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
