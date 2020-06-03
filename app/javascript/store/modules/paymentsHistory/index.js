import { getPayments } from '../../action-types';
import { GET_PAYMENTS_SUCCESS } from '../../mutation-types';
import { getPaymentsApi } from '../../../api/payments.js';

const paymentsState = {
  paymentsHistory: [],
};

const actions = {
  [getPayments]({ commit, dispatch }, payload) {
    return getPaymentsApi(payload)
      .then(res => {
        commit(GET_PAYMENTS_SUCCESS, res.data.data);
        dispatch('user/getUserPaymentHistory', res.data.data, { root: true });

        return;
      })
      .catch(err => {
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
};

const mutations = {
  [GET_PAYMENTS_SUCCESS](state, payments) {
    state.paymentsHistory = payments;
  },
};

export default {
  namespaced: true,
  state: paymentsState,
  mutations,
  actions,
};
