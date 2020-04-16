import { signIn, signOut, signUp, budaSignIn, budaSignOut } from '../../action-types'

import {
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNIN_ATTEMPT,
  SIGNOUT,
  SIGNUP_ATTEMPT,
  SIGNUP_FAIL,
  SIGNUP_SUCCESS,
  BUDA_SIGNIN_ATTEMPT,
  BUDA_SIGNIN_FAIL,
  BUDA_SIGNIN_SUCCESS,
  BUDA_SIGNOUT
} from '../../mutation-types'

import { loginApi, logoutApi, signUpApi, budaSyncApi, getCurrentUserApi } from '../../../api/user.js'

export default {
  [signIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload

    commit(SIGNIN_ATTEMPT)
    const fetchPromise = loginApi(payload)

    return fetchPromise
      .then(res => {
        // Recibe un response correcto (usuario existe, usuario no existe, etc)
        if (res.data.data.attributes) {
          // Usuario logeado correctamente
          localStorage.setItem('currentUser', JSON.stringify(res.data.data.attributes))
          commit(SIGNIN_SUCCESS, res.data.data.attributes)
          dispatch('alert/success_alert', 'Sign in succesfull', { root: true })
          return 
        } else {
          // Algun error de contraseña o usuario no existente
          commit(SIGNIN_FAIL)
          dispatch('alert/error_alert', 'Error al ingresar datos', {
            root: true
          })
          throw new Error("Error al ingresar datos")
        }
      })
      .catch(e => {
        // Hay un error en el fetch
        commit(SIGNIN_FAIL)
        dispatch('alert/error_alert', 'Error desconocido', { root: true })
        throw new Error('Error desconocido')
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
        return 
      })
      .catch(err => {
        dispatch('alert/error_alert', 'Error cerrando sesion', {
          root: true
        })
        throw new Error("Error al ingresar datos")
      })
  },

  [signUp]({ commit, dispatch }, payload) {
    commit(SIGNUP_ATTEMPT)

    // Enviamos la información del Payload a la API para que verifique la validez
    // Hay que verificar que no exista ese email registrado y que tenga usuario buda.

    const fetchPromise = signUpApi(payload)
    return fetchPromise
      .then(res => {
        if (res.data.data.attributes) {
          // Credenciales verificadas
          localStorage.setItem('currentUser', JSON.stringify(res.data.data.attributes))
          commit(SIGNUP_SUCCESS, res.data.data.attributes)
          dispatch('alert/success_alert', 'Sign up succesfull', { root: true })
          return 
        } else {
          // Algun error de contraseña o usuario no existente
          commit(SIGNUP_FAIL)
          dispatch('alert/error_alert', 'Error al ingresar datos', {
            root: true
          })
          throw new Error('Error al ingresar datos')
        }
      })
      .catch(err => {
        // Hay un error en el fetch
        commit(SIGNUP_FAIL)
        dispatch('alert/error_alert', 'Error desconocido', { root: true })
        throw new Error('Error desconocido')
      })
  },
  [budaSignIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload
    const fetchPromise = budaSyncApi(payload)
    return fetchPromise
      .then(res => {
        if (res.data) {
          dispatch('alert/success_alert', 'Cuenta Buda sincronizada correctamente', { root: true })
          const fetchPromiseUser = getCurrentUserApi(payload)
          return fetchPromiseUser
            .then(res => {
              if (res.data.data.attributes){
                localStorage.setItem('currentUser', JSON.stringify(res.data.data.attributes))
                commit(SIGNIN_SUCCESS, res.data.data.attributes)
              }
              return
            })
        }
        else {
          // Error de contraseña
          commit(SIGNUP_FAIL)
          dispatch('alert/error_alert', 'Contraseña incorrecta', {
            root: true
          })
          throw new Error('Contraseña incorrecta')
        }
        
      })
      .catch(err => {
        // Hay un error en el fetch
        dispatch('alert/error_alert', 'Error desconocido', { root: true })
        throw new Error('Error desconocido')
      })
  },
  [budaSignOut]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload (key y secret nulos)
    return budaSyncApi(payload)
      .then(res => {
        if (res.data) {
          // Cuenta buda desconectada correctamente
          localStorage.currentUser.api_key = ''
          commit(BUDA_SIGNOUT)
          dispatch('alert/error_alert', 'Cuenta Buda desconectada correctamente', {
            root: true
          })
          return
        }
        else {
          // Error de contraseña
          commit(SIGNUP_FAIL)
          dispatch('alert/error_alert', 'Contraseña incorrecta', {
            root: true
          })
          throw new Error('Contraseña incorrecta')
        }
      })
      .catch(err => {
        dispatch('alert/error_alert', 'Error desconocido', {
          root: true
        })
        throw new Error("Error ")
      })
  }
}

