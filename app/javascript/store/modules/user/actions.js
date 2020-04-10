import { signIn, signOut } from '../../action-types'

import {
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNIN_ATTEMPT,
  SIGNOUT
} from '../../mutation-types'

import { loginApi, logoutApi } from '../../../api/user.js'

export default {
  [signIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload

    commit(SIGNIN_ATTEMPT)

    // Simulamos success o fail
    const fetchPromise = loginApi(payload)

    return fetchPromise
      .then(res => {
        // Recibe un response correcto (usuario existe, usuario no existe, etc)
        if (res.data.user) {
          // Usuario logeado correctamente
          localStorage.setItem('currentUser', JSON.stringify(res.data.user))
          commit(SIGNIN_SUCCESS, res.data.user)
          dispatch('alert/success_alert', 'Sign in succesfull', { root: true })

          return Promise.resolve()
        } else {
          // Algun error de contraseña o usuario no existente
          commit(SIGNIN_FAIL)
          dispatch('alert/error_alert', 'Error al ingresar datos', {
            root: true
          })
          return Promise.reject()
        }
      })
      .catch(e => {
        // Hay un error en el fetch
        commit(SIGNIN_FAIL)
        dispatch('alert/error_alert', 'Error desconocido', { root: true })
        return Promise.reject()
      })
  },
  [signOut]({ commit, dispatch }, payload) {
    return logoutApi(payload)
      .then(res => {
        localStorage.removeItem('currentUser')
        commit(SIGNOUT)
        dispatch('alert/success_alert', 'Sesion cerrada correctamente', {
          root: true
        })
      })
      .catch(err => {
        localStorage.removeItem('currentUser')
        commit(SIGNOUT)
        dispatch('alert/success_alert', 'Sesion cerrada correctamente', {
          root: true
        })
      })
  }
}
