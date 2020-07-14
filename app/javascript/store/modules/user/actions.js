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
  updateCurrentUser,
  getSplitwiseUrl,
  setSplitwisePaymentData,
  sendSplitwisePayment,
  depositOpenNode,
  withdrawalOpenNode,
  sendRecoveryEmail,
  passwordRecovery,
  budaDirectWithdrawal,
  budaDirectInvoicePay,
  checkEmailExists,
} from '../../action-types';

import {
  GET_CURRENT_USER,
  SIGNIN_FAIL,
  SIGNIN_SUCCESS,
  SIGNIN_ATTEMPT,
  SIGNOUT_ATTEMPT,
  SIGNOUT_SUCCESS,
  SIGNOUT_FAIL,
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
  GET_PAYMENTS_ATTEMPT,
  GET_PAYMENTS_FAIL,
  GET_PAYMENTS_SUCCESS,
  SET_SPLITWISE_PAYMENT_DATA,
  SEND_SPLITWISE_PAYMENT_ATTEMPT,
  SEND_SPLITWISE_PAYMENT_FAIL,
  SEND_SPLITWISE_PAYMENT_SUCCESS,
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
  getSplitwiseUrlApi,
  updateUserApi,
  payOffSplitwiseDebtApi,
  sendRecoveryEmailApi,
  passwordRecoveryApi,
  checkExistingEmail,
} from '../../../api/user.js';

import {
  widthdrawalApi,
  depositApi,
  budaWidthdrawalApi,
  budaDirectInvoicePayApi,
} from '../../../api/wallet';

import { validateEmail } from '../../../helpers';

const commitAndSetUser = ({ commit, mutation, user }) => {
  if (user) {
    localStorage.setItem('currentUser', JSON.stringify(user));
    commit(mutation, user);
  }
};

const checkRecoveryParams = (
  email,
  token,
  passwordOne,
  passwordTwo,
  dispatch
) => {
  if (!passwordOne || !passwordTwo || !token || !email) {
    dispatch('alert/errorAlert', 'Faltan datos', {
      root: true,
    });

    return false;
  }

  if (passwordOne !== passwordTwo) {
    dispatch('alert/errorAlert', 'Las contraseñas no son iguales', {
      root: true,
    });

    return false;
  }
  if (!validateEmail(email)) {
    dispatch('alert/errorAlert', 'Datos incorrectos', {
      root: true,
    });

    return false;
  }

  return true;
};

export default {
  [getCurrentUser]({ dispatch, commit }, payload) {
    return getCurrentUserApi()
      .then(res => {
        const currentUser = res.data.data.attributes;
        currentUser.authentication_token = payload.authentication_token;

        localStorage.setItem('currentUser', JSON.stringify(currentUser));
        commit(GET_CURRENT_USER, currentUser);
      })
      .catch(e => {
        // no logramos cargar los otros datos del usuario, cerramos la sesion
        // eslint-disable-next-line no-console
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
        commitAndSetUser({
          commit,
          mutation: SIGNIN_SUCCESS,
          user: {
            authentication_token,
            email: payload.email,
            api_key: '',
            picture_url: null,
          },
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
            { root: true }
          );
          throw new Error('Error desconocido');
        } else {
          // Error en el fetch
          commit(SIGNIN_FAIL);
          dispatch(
            'alert/errorAlert',
            'Error desconocido, intente nuevamente',
            { root: true }
          );
          throw new Error('Error desconocido');
        }
      });
  },
  [signOut]({ commit, dispatch }) {
    commit(SIGNOUT_ATTEMPT);

    return logoutApi()
      .then(() => {
        localStorage.removeItem('currentUser');
        commit(SIGNOUT_SUCCESS);
        dispatch('alert/successAlert', 'Sesión cerrada correctamente', {
          root: true,
        });

        return;
      })
      .catch(err => {
        commit(SIGNOUT_FAIL);
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
            }
          );
          throw new Error('Error al ingresar datos');
        }
      });
  },
  [signUp]({ commit, dispatch }, payload) {
    commit(SIGNUP_ATTEMPT);

    return (
      signUpApi(payload)
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
        })
    );
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
            { root: true }
          );
          const fetchPromiseUser = getCurrentUserApi();

          return fetchPromiseUser;
        }
        // Credenciales inválidas

        dispatch(
          'alert/errorAlert',
          'Datos incorrectos. Revise los datos ingresados',
          { root: true }
        );
        throw new Error('Datos incorrectos. Revise los datos ingresados');
      })
      .then(res => {
        commitAndSetUser({
          commit,
          mutation: BUDA_SIGNIN_SUCCESS,
          user: { ...state.currentUser, ...res.data.data.attributes },
        });
      })
      .catch(err => {
        commit(BUDA_SIGNIN_FAIL);
        payload.api_key = '';
        payload.api_secret = '';

        return budaSyncApi(payload)
          .then(() => {
            const fetchPromiseUser = getCurrentUserApi();

            return fetchPromiseUser.then(res => {
              commitAndSetUser({
                commit,
                mutation: BUDA_SIGNIN_SUCCESS,
                user: { ...state.currentUser, ...res.data.data.attributes },
              });
            });
          })
          .then(() => {
            if (err.response || err.message) {
              dispatch(
                'alert/errorAlert',
                'Datos incorrectos. Revise los datos ingresados',
                { root: true }
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
          { root: true }
        );
        const fetchPromiseUser = getCurrentUserApi();

        return fetchPromiseUser.then(res => {
          commitAndSetUser({
            commit,
            mutation: BUDA_SIGNOUT,
            user: { ...state.currentUser, ...res.data.data.attributes },
          });
        });
      })
      .catch(err => {
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error desconectando cuenta. Revise la contraseña ingresada',
            { root: true }
          );
          throw new Error(
            'Error desconectando cuenta. Revise la contraseña ingresada'
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
            { root: true }
          );
          throw new Error(
            'Error obteniendo cotización. Revise los datos ingresados'
          );
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getUserBalance]({ commit, dispatch }, payload) {
    commit(GET_USER_BALANCE_ATTEMPT);

    return getUserBalanceApi(payload)
      .then(res => {
        commit(GET_USER_BALANCE_SUCCESS, res.data.data.balance);

        return;
      })
      .catch(err => {
        commit(GET_USER_BALANCE_FAIL);
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo balance. Revise sus datos de cuenta',
            { root: true }
          );
          throw new Error(
            'Error obteniendo balance. Revise sus datos de cuenta'
          );
        } else {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo su balance, revise sus datos de cuenta o agregue sus credenciales de buda.',
            { root: true }
          );
          throw new Error('Error desconocido');
        }
      });
  },
  [sendPayment]({ commit, dispatch }, payload) {
    commit(SEND_PAYMENT_ATTEMPT);

    return sendPaymentApi(payload)
      .then(() => {
        commit(SEND_PAYMENT_SUCCESS, { data: payload });
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
            { root: true }
          );
          throw new Error('Error enviando pago. Revise los datos ingresados');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getPayments]({ commit, dispatch }, payload) {
    commit(GET_PAYMENTS_ATTEMPT);

    return getPaymentsApi(payload)
      .then(res => {
        commit(GET_PAYMENTS_SUCCESS, res.data.data);

        return;
      })
      .catch(err => {
        commit(GET_PAYMENTS_FAIL);
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo el historial de transacciones.',
            { root: true }
          );
          throw new Error('Error obteniendo el historial de transacciones.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [getSplitwiseUrl]({ dispatch }, payload) {
    return getSplitwiseUrlApi(payload)
      .then(res => res.data.data.attributes)
      .catch(err => {
        if (err.response) {
          dispatch('alert/errorAlert', 'Error redireccionando a Splitwise.', {
            root: true,
          });
          throw new Error('Error redireccionando a Splitwise.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [setSplitwisePaymentData]({ commit }, payload) {
    commit(SET_SPLITWISE_PAYMENT_DATA, payload);
  },
  [sendSplitwisePayment]({ commit, dispatch }, payload) {
    commit(SEND_SPLITWISE_PAYMENT_ATTEMPT);
    console.log(payload);

    return sendPaymentApi(payload)
      .then(() =>
        payOffSplitwiseDebtApi(payload).then(() => {
          commit(SEND_SPLITWISE_PAYMENT_SUCCESS, { data: payload });
          dispatch('alert/successAlert', 'Deuda saldada correctamente', {
            root: true,
          });

          return;
        })
      )
      .catch(err => {
        commit(SEND_SPLITWISE_PAYMENT_FAIL);
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error enviando pago. Revise los datos ingresados',
            { root: true }
          );
          throw new Error('Error enviando pago. Revise los datos ingresados');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
  [depositOpenNode]({ dispatch }, { amount, currency }) {
    if (!amount || !currency) {
      return Promise.reject('Error');
    }

    return depositApi({ amount, currency })
      .then(res => {
        const { data } = res.data;
        dispatch('alert/successAlert', 'Solicitud recibida con exito', {
          root: true,
        });

        return data;
      })
      .catch(err => {
        // if (err.response) {
        dispatch('alert/errorAlert', 'Algo salio mal', {
          root: true,
        });

        throw Error(err);
        // }
      });
  },
  [withdrawalOpenNode]({ dispatch }, { invoice }) {
    if (!invoice) {
      return Promise.reject('Error');
    }

    return widthdrawalApi({ invoice })
      .then(res => {
        const { data } = res.data;
        dispatch('alert/successAlert', 'Solicitud recibida con exito', {
          root: true,
        });

        return data;
      })
      .catch(err => {
        // if (err.response) {
        dispatch('alert/errorAlert', 'Algo salio mal', {
          root: true,
        });

        throw Error(err);
        // }
      });
  },
  [updateCurrentUser]({ state, dispatch }, payload) {
    if (
      (state.currentUser.api_key === '' ||
        state.currentUser.api_key === null) &&
      payload.wallet === 'buda'
    ) {
      dispatch('alert/errorAlert', 'No tiene su cuenta sincronizada con Buda', {
        root: true,
      });

      return Promise.reject();
    }

    return updateUserApi(payload)
      .then(() => {
        // commit(succes)
        dispatch('alert/successAlert', 'Cambio exitoso!', {
          root: true,
        });
      })
      .catch(error => {
        if (error.response) {
          dispatch('alert/errorAlert', 'Contraseña incorrecta', {
            root: true,
          });
        } else {
          dispatch(
            'alert/errorAlert',
            'Error desconocido, intente nuevamente',
            {
              root: true,
            }
          );
        }
      });
  },

  [sendRecoveryEmail]({ dispatch }, payload) {
    const { email } = payload;
    if (!validateEmail(email)) {
      dispatch('alert/errorAlert', 'Ingrese un mail valido', {
        root: true,
      });

      return Promise.reject('invalid format');
    }

    return sendRecoveryEmailApi(email)
      .then(() => {
        dispatch('alert/successAlert', 'Se envió el correo de recuperación', {
          root: true,
        });

        return;
      })
      .catch(error => {
        if (error.response) {
          dispatch('alert/errorAlert', 'No hay un usuario con ese email', {
            root: true,
          });
        } else {
          dispatch(
            'alert/errorAlert',
            'Falta el endpoint en el backend',

            {
              root: true,
            }
          );
        }

        throw Error(error);
      });
  },
  [passwordRecovery]({ dispatch }, payload) {
    const { email, recoveryToken, passwordOne, passwordTwo } = payload;

    if (
      !checkRecoveryParams(
        email,
        recoveryToken,
        passwordOne,
        passwordTwo,
        dispatch
      )
    ) {
      return Promise.reject('error');
    }

    return passwordRecoveryApi({ token: recoveryToken, password: passwordOne })
      .then(() => {
        dispatch(
          'alert/successAlert',
          '¡Se ha seteado la nueva contraseña con éxito!',
          {
            root: true,
          }
        );

        return;
      })
      .catch(error => {
        if (error.response) {
          dispatch('alert/errorAlert', 'Los datos ingresados son incorrectos', {
            root: true,
          });
        } else {
          dispatch('alert/errorAlert', 'Falta el endpoint en el backend', {
            root: true,
          });
        }

        throw Error(error);
      });
  },
  [budaDirectWithdrawal]({ dispatch }, payload) {
    return budaWidthdrawalApi(payload)
      .then(res => {
        // Ahora bitsplit debe pagar ese invoice
        const { invoice } = res.data;

        return invoice;
      })
      .catch(error => {
        if (error.response) {
          dispatch('alert/errorAlert', 'Revisa tu saldo o tus datos de Buda', {
            root: true,
          });
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', {
            root: true,
          });
        }

        throw Error(error);
      });
  },
  [budaDirectInvoicePay]({ dispatch }, payload) {
    return budaDirectInvoicePayApi(payload)
      .then(() => {
        dispatch('alert/successAlert', '¡Se ha hecho el deposito con exito!', {
          root: true,
        });

        return;
      })
      .catch(error => {
        if (error.response) {
          dispatch('alert/errorAlert', 'Revisa tu saldo o tus datos de Buda', {
            root: true,
          });
        } else {
          dispatch('alert/errorAlert', 'Error desconocido', {
            root: true,
          });
        }

        throw Error(error);
      });
  },
  [checkEmailExists](_, payload) {
    const { email } = payload;

    return checkExistingEmail({ email })
      .then(res => res.data.data.attributes.user_exists)
      .catch(error => {
        if (error.response) {
          return false;
        }

        throw Error(error);
      });
  },
};
