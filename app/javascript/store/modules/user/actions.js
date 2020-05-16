import {
  signIn,
  signOut,
  signUp,
  budaSignIn,
  budaSignOut,
  getQuotation,
  getUserBalance,
  sendPayment,
  getPayments,
  splitwiseUrlConnection,
  getDebts
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
  GET_USER_BALANCE_ATTEMPT,
  GET_USER_BALANCE_FAIL,
  GET_USER_BALANCE_SUCCESS,
  SEND_PAYMENT_ATTEMPT,
  SEND_PAYMENT_FAIL,
  SEND_PAYMENT_SUCCESS,
  GET_PAYMENTS_SUCCESS,
  GET_DEBTS_SUCCESS
} from '../../mutation-types'

import {
  loginApi,
  logoutApi,
  signUpApi,
  budaSyncApi,
  getCurrentUserApi,
  getQuotationApi,
  getUserBalanceApi,
  sendPaymentApi,
  getPaymentsApi,
  splitwiseUrlConnectionApi,
  getDebtsApi
} from '../../../api/user.js'

export default {
  [signIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload

    commit(SIGNIN_ATTEMPT)
    const fetchPromise = loginApi(payload)

    return fetchPromise
      .then(res => {
        dispatch('alert/success_alert', 'Usuario ingresado correctamente', {
          root: true
        })
        commitAndSetUser({ commit, mutation: SIGNIN_SUCCESS, user: res })
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
        dispatch('alert/success_alert', 'Usuario creado correctamente', {
          root: true
        })
        commitAndSetUser({ commit, mutation: SIGNUP_SUCCESS, user: res })
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
    commit(BUDA_SIGNIN_ATTEMPT)
    const fetchPromise = budaSyncApi(payload)
    return fetchPromise
      .then(res => {
        // Buscamos verificar credenciales Buda
        const checkPromise = getUserBalanceApi(payload)
        return checkPromise
      })
      .then(res => {
        // Credenciales válidas
        if (res.data.data.balance) {
          dispatch(
            'alert/success_alert',
            'Cuenta Buda sincronizada correctamente',
            { root: true }
          )
          const fetchPromiseUser = getCurrentUserApi()
          return fetchPromiseUser
        }
        // Credenciales inválidas
        else {
          dispatch('alert/error_alert',
                   'Datos incorrectos. Revise los datos ingresados',
                   { root: true }
          )
          throw new Error('Datos incorrectos. Revise los datos ingresados')
        }
      })
      .then(res => {
        commitAndSetUser({ commit, mutation: BUDA_SIGNIN_SUCCESS, user: res })
      })
      .catch(err => {
        commit(BUDA_SIGNIN_FAIL)
        payload.api_key = ''
        payload.api_secret = ''
        const fetchPromise = budaSyncApi(payload)
        return fetchPromise
          .then(res => {
            const fetchPromiseUser = getCurrentUserApi()
            return fetchPromiseUser
              .then(res => {
                commitAndSetUser({ commit, mutation: BUDA_SIGNOUT, user: res })
              })
          })
          .then(res => {
            if (err.response || err.message) {
              dispatch('alert/error_alert',
                      'Datos incorrectos. Revise los datos ingresados',
                      { root: true }
              )
              throw new Error('Datos incorrectos. Revise los datos ingresados')
            } else {
              dispatch('alert/error_alert', 'Error desconocido', { root: true })
              throw new Error('Error desconocido',)
            }
          })
      })
  },
  [budaSignOut]({ commit, dispatch }, payload) {
    const fetchPromise = budaSyncApi(payload)
    return fetchPromise
      .then(res => {
        dispatch(
          'alert/success_alert',
          'Cuenta Buda desconectada correctamente',
          { root: true }
        )
        const fetchPromiseUser = getCurrentUserApi()
        return fetchPromiseUser
          .then(res => {
            commitAndSetUser({ commit, mutation: BUDA_SIGNOUT, user: res })
          })
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error desconectando cuenta. Revise la contraseña ingresada',
            { root: true }
          )
          throw new Error(
            'Error desconectando cuenta. Revise la contraseña ingresada'
          )
        } else {
          dispatch('alert/error_alert', 'Error desconocido', { root: true })
          throw new Error('Error desconocido')
        }
      })
  },
  [getQuotation]({ commit, dispatch }, payload) {
    return getQuotationApi(payload)
      .then(res => {
        return res.data.data.quotation
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error obteniendo cotización. Revise los datos ingresados',
            { root: true }
          )
          throw new Error(
            'Error obteniendo cotización. Revise los datos ingresados'
          )
        } else {
          dispatch('alert/error_alert', 'Error desconocido.', { root: true })
          throw new Error('Error desconocido')
        }
      })
  },
  [getUserBalance]({ commit, dispatch }, payload) {
    return getUserBalanceApi(payload)
      .then(res => {
        commit(GET_USER_BALANCE_SUCCESS, res.data.data.balance)
        return
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error obteniendo balance. Revise sus datos de cuenta',
            { root: true }
          )
          throw new Error(
            'Error obteniendo balance. Revise sus datos de cuenta'
          )
        } else {
          dispatch(
            'alert/error_alert',
            'Error obteniendo su balance, revise sus datos de cuenta o agregue sus credenciales de buda.',
            { root: true }
          )
          throw new Error('Error desconocido')
        }
      })
  },
  [sendPayment]({ commit, dispatch }, payload) {
    commit(SEND_PAYMENT_ATTEMPT)
    return sendPaymentApi(payload)
      .then(res => {
        commit(SEND_PAYMENT_SUCCESS, res.data.data.attributes)
        dispatch('alert/success_alert', 'Pago realizado correctamente', {
          root: true
        })
        return
      })
      .catch(err => {
        commit(SEND_PAYMENT_FAIL)
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error enviando pago. Revise los datos ingresados',
            { root: true }
          )
          throw new Error('Error enviando pago. Revise los datos ingresados')
        } else {
          dispatch('alert/error_alert', 'Error desconocido', { root: true })
          throw new Error('Error desconocido')
        }
      })
  },
  [getPayments]({ commit, dispatch }, payload) {
    return getPaymentsApi(payload)
      .then(res => {
        commit(GET_PAYMENTS_SUCCESS, res.data.data)
        return
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error obteniendo el historial de transacciones.',
            { root: true }
          )
          throw new Error('Error obteniendo el historial de transacciones.')
        } else {
          dispatch('alert/error_alert', 'Error desconocido.', { root: true })
          throw new Error('Error desconocido')
        }
      })
  },
  [splitwiseUrlConnection]({ commit, dispatch }, payload) {
    return splitwiseUrlConnectionApi(payload)
      .then(res => {
        return res.data.data.attributes
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error redireccionando a Splitwise.',
            { root: true }
          )
          throw new Error('Error redireccionando a Splitwise.')
        } else {
          dispatch('alert/error_alert', 'Error desconocido.', { root: true })
          throw new Error('Error desconocido')
        }
      })
  },
  [getDebts]({ commit, dispatch }, payload) {
    return getDebtsApi(payload)
      .then(res => {
        commit(GET_DEBTS_SUCCESS, res.data.data.attributes)
        return
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/error_alert',
            'Error obteniendo las deudas de Splitwise.',
            { root: true }
          )
          throw new Error('Error obteniendo las deudas de Splitwise.')
        } else {
          dispatch('alert/error_alert', 'Error desconocido.', { root: true })
          throw new Error('Error desconocido')
        }
      })
  }
}

function commitAndSetUser({ commit, mutation, user }) {
  if (user.data.data.attributes) {
    localStorage.setItem(
      'currentUser',
      JSON.stringify(user.data.data.attributes)
    )
    commit(mutation, user.data.data.attributes)
  }
}