import {
  signIn,
  signOut,
  signUp,
  budaSignIn,
  budaSignOut,
  getQuotation,
  getUserBalance,
  sendPayment
} from '../../action-types'

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
  BUDA_SIGNOUT,
  GET_QUOTATION_ATTEMPT,
  GET_QUOTATION_FAIL,
  GET_QUOTATION_SUCCESS,
  GET_USER_BALANCE_ATTEMPT,
  GET_USER_BALANCE_FAIL,
  GET_USER_BALANCE_SUCCESS,
  SEND_PAYMENT_ATTEMPT,
  SEND_PAYMENT_FAIL,
  SEND_PAYMENT_SUCCESS
} from '../../mutation-types'

import {
  loginApi,
  logoutApi,
  signUpApi,
  budaSyncApi,
  getCurrentUserApi,
  getQuotationApi,
  getUserBalanceApi,
  sendPaymentApi
} from '../../../api/user.js'

export default {
  [signIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload

    commit(SIGNIN_ATTEMPT)
    const fetchPromise = loginApi(payload)

    return fetchPromise
      .then(res => {
        const user = res.data.data.attributes
        localStorage.setItem('currentUser', JSON.stringify(user))
        commit(SIGNIN_SUCCESS, user)
        dispatch('alert/success_alert', 'Usuario ingresado correctamente', {
          root: true
        })
      })
      .catch(e => {
        if (e.response) {
          // Algun error de backend
          commit(SIGNIN_FAIL)
          dispatch(
            'alert/error_alert',
            'Error iniciando sesion (revise credenciales otorgadas)',
            { root: true }
          )
          throw new Error('Error desconocido')
        } else {
          // Error en el fetch
          commit(SIGNIN_FAIL)
          dispatch(
            'alert/error_alert',
            'Error desconocido, intente nuevamente',
            { root: true }
          )
          throw new Error('Error desconocido')
        }
      })
  },
  [signOut]({ commit, dispatch }) {
    return logoutApi()
      .then(res => {
        localStorage.removeItem('currentUser')
        commit(SIGNOUT)
        dispatch('alert/success_alert', 'Sesión cerrada correctamente', {
          root: true
        })
        return
      })
      .catch(err => {
        if (err.response) {
          dispatch('alert/error_alert', 'Error interno, intente nuevamente', {
            root: true
          })
          throw new Error('Error al ingresar datos')
        } else {
          dispatch(
            'alert/error_alert',
            'Error cerrando sesion, intente nuevamente',
            {
              root: true
            }
          )
          throw new Error('Error al ingresar datos')
        }
      })
  },

  [signUp]({ commit, dispatch }, payload) {
    commit(SIGNUP_ATTEMPT)

    // Enviamos la información del Payload a la API para que verifique la validez
    // Hay que verificar que no exista ese email registrado y que tenga usuario buda.

    return signUpApi(payload)
      .then(res => {
        const user = res.data.data.attributes
        localStorage.setItem('currentUser', JSON.stringify(user))
        commit(SIGNUP_SUCCESS, user)
        dispatch('alert/success_alert', 'Usuario creado correctamente', {
          root: true
        })
      })
      .catch(err => {
        if (err.response) {
          const { errors } = err.response.data
          let errorMessage = ''
          const fields = Object.keys(errors)
          for (const field of fields) {
            errorMessage = `${errorMessage} ${field}: ${errors[field]}  `
          }

          commit(SIGNUP_FAIL)
          dispatch('alert/error_alert', errorMessage, {
            root: true
          })
          throw new Error('Error interno')
        } else {
          commit(SIGNUP_FAIL)
          dispatch('alert/error_alert', 'Error interno, intente nuevamente', {
            root: true
          })
          throw new Error('Error interno')
        }
      })
  },
  [budaSignIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload
    const fetchPromise = budaSyncApi(payload)
    return fetchPromise
      .then(res => {
        if (res.data) {
          dispatch(
            'alert/success_alert',
            'Cuenta Buda sincronizada correctamente',
            { root: true }
          )
          const fetchPromiseUser = getCurrentUserApi()
          return fetchPromiseUser.then(res => {
            if (res.data.data.attributes) {
              localStorage.setItem(
                'currentUser',
                JSON.stringify(res.data.data.attributes)
              )
              commit(SIGNIN_SUCCESS, res.data.data.attributes)
            }
            return
          })
        } else {
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
          dispatch(
            'alert/success_alert',
            'Cuenta Buda desconectada correctamente',
            {
              root: true
            }
          )
          return
        } else {
          // Error de contraseña
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
        throw new Error('Error desconocido')
      })
  },
  [getQuotation]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload (key y secret nulos)
    return getQuotationApi(payload)
      .then(res => {
        if (res.data) {
          commit(GET_QUOTATION_SUCCESS, res.data.data.quotation)
          return
        }
      })
      .catch(err => {
        dispatch('alert/error_alert', 'Error desconocido', {
          root: true
        })
        throw new Error('Error desconocido')
      })
  },
  [getUserBalance]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload (key y secret nulos)
    return getUserBalanceApi(payload)
      .then(res => {
        if (res.data) {
          commit(GET_USER_BALANCE_SUCCESS, res.data.data.balance)
          return
        }
      })
      .catch(err => {
        dispatch('alert/error_alert', 'Error desconocido', {
          root: true
        })
        throw new Error('Error desconocido')
      })
  },
  [sendPayment]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload (key y secret nulos)
    return sendPaymentApi(payload)
      .then(res => {
        if (res.data) {
          commit(SEND_PAYMENT_SUCCESS, res.data)
          return
        } else {
          dispatch('alert/error_alert', 'Datos incorrectos', {
            root: true
          })
          throw new Error('Datos incorrectos')
        }
      })
      .catch(err => {
        dispatch('alert/error_alert', 'Error desconocido', {
          root: true
        })
        throw new Error('Error desconocido')
      })
  }
}
