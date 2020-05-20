import {
  getCurrentUser,
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
  getDebts,
} from '../../action-types';

import {
  GET_CURRENT_USER,
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
  GET_USER_BALANCE_SUCCESS,
  SEND_PAYMENT_ATTEMPT,
  SEND_PAYMENT_FAIL,
  SEND_PAYMENT_SUCCESS,
  GET_PAYMENTS_SUCCESS,
  GET_DEBTS_SUCCESS,
} from '../../mutation-types';

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
  getDebtsApi,
} from '../../../api/user.js';

const commitAndSetUser = ({ commit, mutation, user }) => {
  if (user) {
    localStorage.setItem(
      'currentUser',
      JSON.stringify(user),
    );
    commit(mutation, user);
  }
};

export default {
  [getCurrentUser]({ dispatch, commit }, payload) {
    return getCurrentUserApi()
      .then((res) => {
        const currentUser = res.data.data.attributes;
        currentUser.authentication_token = payload.authentication_token;

        localStorage.setItem(
          'currentUser',
          JSON.stringify(currentUser),
        );
        commit(GET_CURRENT_USER, currentUser);
      }).catch(e => {
        // no logramos cargar los otros datos del usuario, cerramos la sesion
        console.error(e);
        dispatch(signOut);
      });
  },
  [signIn]({ commit, dispatch }, payload) {
    // Hacemos fetch a la api con data de payload

    commit(SIGNIN_ATTEMPT);
    const fetchPromise = loginApi(payload);

    return fetchPromise
      .then(res => {
        dispatch('alert/successAlert', 'Usuario ingresado correctamente', {
          root: true,
        });

        const { authentication_token } = res.data;

        // SignIn fue exitosa, seteamos informacion con un placeholder
        commitAndSetUser({ commit,
          mutation: SIGNIN_SUCCESS,
          user: { authentication_token,
            email: payload.email,
            api_key: '',
            picture_url: null },
        });
        // SignIn fue exitosa
        dispatch(getCurrentUser, { authentication_token });
      })
      .catch(e => {
        if (e.response) {
          // Algun error de backend
          commit(SIGNIN_FAIL);
          dispatch(
            'alert/errorAlert',
            'Error iniciando sesion (revise credenciales otorgadas)',
            { root: true },
          );
          throw new Error('Error desconocido');
        } else {
          // Error en el fetch
          commit(SIGNIN_FAIL);
          dispatch(
            'alert/errorAlert',
            'Error desconocido, intente nuevamente',
            { root: true },
          );
          throw new Error('Error desconocido');
        }
      });
  },
  [signOut]({ commit, dispatch }) {
    return logoutApi()
      .then(() => {
        localStorage.removeItem('currentUser');
        commit(SIGNOUT);
        dispatch('alert/successAlert', 'Sesión cerrada correctamente', {
          root: true,
        });

        return;
      })
      .catch(err => {
        if (err.response) {
          dispatch('alert/errorAlert', 'Error interno, intente nuevamente', {
            root: true,
          });
          throw new Error('Error al ingresar datos');
        } else {
          dispatch(
            'alert/errorAlert',
            'Error cerrando sesion, intente nuevamente',
            {
              root: true,
            },
          );
          throw new Error('Error al ingresar datos');
        }
      });
  },
  [signUp]({ commit, dispatch }, payload) {
    commit(SIGNUP_ATTEMPT);

    return signUpApi(payload)
      .then(() => {
        dispatch('alert/successAlert', 'Usuario creado correctamente', {
          root: true,
        });

        // No lo logeamos, lo mandamos para que lo haga manualmente
        commit(SIGNUP_SUCCESS);
      })
      // eslint-disable-next-line max-statements
      .catch(err => {
        if (err.response) {
          const { errors } = err.response.data;
          let errorMessage = '';
          const fields = Object.keys(errors);
          for (const field of fields) {
            errorMessage = `${errorMessage} ${field}: ${errors[field]}  `;
          }

          commit(SIGNUP_FAIL);
          dispatch('alert/errorAlert', errorMessage, {
            root: true,
          });
          throw new Error('Error interno');
        } else {
          commit(SIGNUP_FAIL);
          dispatch('alert/errorAlert', 'Error interno, intente nuevamente', {
            root: true,
          });
          throw new Error('Error interno');
        }
      });
  },
  [budaSignIn]({ state, commit, dispatch }, payload) {
    commit(BUDA_SIGNIN_ATTEMPT);
    const fetchPromise = budaSyncApi(payload);

    return fetchPromise
      .then(() => {
        // Buscamos verificar credenciales Buda
        const checkPromise = getUserBalanceApi(payload);

        return checkPromise;
      })
      .then(res => {
        // Credenciales válidas
        if (res.data.data.balance) {
          dispatch(
            'alert/successAlert',
            'Cuenta Buda sincronizada correctamente',
            { root: true },
          );
          const fetchPromiseUser = getCurrentUserApi();

          return fetchPromiseUser;
        }
        // Credenciales inválidas

        dispatch('alert/errorAlert',
          'Datos incorrectos. Revise los datos ingresados',
          { root: true },
        );
        throw new Error('Datos incorrectos. Revise los datos ingresados');
      })
      .then(res => {
        commitAndSetUser({ commit, mutation: BUDA_SIGNIN_SUCCESS, user: { ...state.currentUser, ...res.data.data.attributes } });
      })
      .catch(err => {
        commit(BUDA_SIGNIN_FAIL);
        payload.api_key = '';
        payload.api_secret = '';

        return budaSyncApi(payload)
          .then(() => {
            const fetchPromiseUser = getCurrentUserApi();

            return fetchPromiseUser
              .then(res => {
                commitAndSetUser({ commit, mutation: BUDA_SIGNIN_SUCCESS, user: { ...state.currentUser, ...res.data.data.attributes } });
              });
          })
          .then(() => {
            if (err.response || err.message) {
              dispatch('alert/errorAlert',
                'Datos incorrectos. Revise los datos ingresados',
                { root: true },
              );
              throw new Error('Datos incorrectos. Revise los datos ingresados');
            } else {
              dispatch('alert/errorAlert', 'Error desconocido', { root: true });
              throw new Error('Error desconocido');
            }
          });
      });
  },
  [budaSignOut]({ state, commit, dispatch }, payload) {
    const fetchPromise = budaSyncApi(payload);

    return fetchPromise
      .then(() => {
        dispatch(
          'alert/successAlert',
          'Cuenta Buda desconectada correctamente',
          { root: true },
        );
        const fetchPromiseUser = getCurrentUserApi();

        return fetchPromiseUser
          .then(res => {
            commitAndSetUser({ commit, mutation: BUDA_SIGNOUT, user: { ...state.currentUser, ...res.data.data.attributes } });
          });
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error desconectando cuenta. Revise la contraseña ingresada',
            { root: true },
          );
          throw new Error(
            'Error desconectando cuenta. Revise la contraseña ingresada',
          );
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getQuotation]({ dispatch }, payload) {
    return getQuotationApi(payload)
      .then(res => res.data.data.quotation)
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo cotización. Revise los datos ingresados',
            { root: true },
          );
          throw new Error(
            'Error obteniendo cotización. Revise los datos ingresados',
          );
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getUserBalance]({ commit, dispatch }, payload) {
    return getUserBalanceApi(payload)
      .then(res => {
        commit(GET_USER_BALANCE_SUCCESS, res.data.data.balance);

        return;
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo balance. Revise sus datos de cuenta',
            { root: true },
          );
          throw new Error(
            'Error obteniendo balance. Revise sus datos de cuenta',
          );
        } else {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo su balance, revise sus datos de cuenta o agregue sus credenciales de buda.',
            { root: true },
          );
          throw new Error('Error desconocido');
        }
      });
  },
  [sendPayment]({ commit, dispatch }, payload) {
    commit(SEND_PAYMENT_ATTEMPT);

    return sendPaymentApi(payload)
      .then(res => {
        commit(SEND_PAYMENT_SUCCESS, res.data.data.attributes);
        dispatch('alert/successAlert', 'Pago realizado correctamente', {
          root: true,
        });

        return;
      })
      .catch(err => {
        commit(SEND_PAYMENT_FAIL);
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error enviando pago. Revise los datos ingresados',
            { root: true },
          );
          throw new Error('Error enviando pago. Revise los datos ingresados');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getPayments]({ commit, dispatch }, payload) {
    return getPaymentsApi(payload)
      .then(res => {
        commit(GET_PAYMENTS_SUCCESS, res.data.data);

        return;
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo el historial de transacciones.',
            { root: true },
          );
          throw new Error('Error obteniendo el historial de transacciones.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [splitwiseUrlConnection]({ dispatch }, payload) {
    return splitwiseUrlConnectionApi(payload)
      .then(res => res.data.data.attributes)
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error redireccionando a Splitwise.',
            { root: true },
          );
          throw new Error('Error redireccionando a Splitwise.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getDebts]({ commit, dispatch }, payload) {
    return getDebtsApi(payload)
      .then(res => {
        commit(GET_DEBTS_SUCCESS, res.data.data.attributes);

        return;
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo las deudas de Splitwise.',
            { root: true },
          );
          throw new Error('Error obteniendo las deudas de Splitwise.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
};

