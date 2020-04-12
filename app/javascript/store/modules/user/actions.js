import { signIn, signOut, signUp } from './../../action-types'

import {
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNIN_ATTEMPT,
  SIGNOUT,
  SIGNUP_ATTEMPT,
  SIGNUP_FAIL,
  SIGNUP_SUCCESS
} from './../../mutation-types'

import { loginApi, logoutApi, signUpApi } from './../../../api/user.js'

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
    logoutApi(payload)
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
  },
  [signUp]({ commit, dispatch }, payload) {

    commit(SIGNUP_ATTEMPT)

    // Enviamos la información del Payload a la API para que verifique la validez
    // Hay que verificar que no exista ese email registrado y que tenga usuario buda.

    const fetchPromise = signUpApi(payload)
    
    console.log ('fetch',fetchPromise)
    return fetchPromise
      .then(res => {
        if (res.data.user) {
          print('respuesta api', res.data.data.user)
          // Credenciales verificadas
          commit(SIGNUP_SUCCESS, res.data.user)
          dispatch('alert/success_alert', 'Sign in succesfull', { root: true })
          return Promise.resolve()
        } 
        else {
          // Algun error de contraseña o usuario no existente
          commit(SIGNUP_FAIL)
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
}