import { getPayments } from '../../action-types';

import {
  GET_PAYMENTS_ATTEMPT,
  GET_PAYMENTS_FAIL,
  GET_PAYMENTS_SUCCESS,
} from '../../mutation-types';

import { getPaymentsApi } from '../../../api/payments-history.js';

const paymentsHistoryState = {
  getPaymentsHistoryLoading: false,
  userPaymentsHistory: [],
};

const actions = {
  [getPayments]({ commit, dispatch }, payload) {
    commit(GET_PAYMENTS_ATTEMPT);

    return getPaymentsApi(payload)
      .then(res => {
        commit(GET_PAYMENTS_SUCCESS, res.data.data.transactions);

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
};

const mutations = {
  [GET_PAYMENTS_ATTEMPT](state) {
    state.getPaymentsHistoryLoading = true;
  },
  [GET_PAYMENTS_FAIL](state) {
    state.getPaymentsHistoryLoading = false;
  },
  [GET_PAYMENTS_SUCCESS](state, payments) {
    state.getPaymentsHistoryLoading = false;
    state.userPaymentsHistory = payments;
  },
};

export default {
  namespaced: true,
  state: paymentsHistoryState,
  actions,
  mutations,
};
