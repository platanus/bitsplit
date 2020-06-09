import { getSplitwiseDebts } from '../../action-types';

import {
  GET_SPLIWITSE_DEBTS_ATTEMPT,
  GET_SPLIWITSE_DEBTS_FAIL,
  GET_SPLIWITSE_DEBTS_SUCCESS,
} from '../../mutation-types';

import { getSplitwiseDebtsApi } from '../../../api/user.js';

import { groupDebtsById } from '../../../helpers';

const splitwiseDebtsState = {
  getSplitwiseDebtsLoading: false,
  userSplitwiseDebts: [],
};

const actions = {
  [getSplitwiseDebts]({ commit, dispatch }, payload) {
    commit(GET_SPLIWITSE_DEBTS_ATTEMPT);

    return getSplitwiseDebtsApi(payload)
      .then(res => {
        commit(GET_SPLIWITSE_DEBTS_SUCCESS, {
          debts: res.data.data.attributes
        });

        return;
      })
      .catch(err => {
        commit(GET_SPLIWITSE_DEBTS_FAIL);
        if (err.response) {
          dispatch(
            'alert/errorAlert',
            'Error obteniendo las deudas de Splitwise.',
            { root: true }
          );
          throw new Error('Error obteniendo las deudas de Splitwise.');
        } else {
          dispatch('alert/errorAlert', 'Error desconocido.', { root: true });
          throw new Error('Error desconocido');
        }
      });
  },
};

const mutations = {
  [GET_SPLIWITSE_DEBTS_ATTEMPT](state) {
    state.getSplitwiseDebtsLoading = true;
  },
  [GET_SPLIWITSE_DEBTS_FAIL](state) {
    state.getSplitwiseDebtsLoading = false;
  },
  [GET_SPLIWITSE_DEBTS_SUCCESS](state, debts) {
    state.getSplitwiseDebtsLoading = false;
    const debtsByGroup = groupDebtsById(
      debts.debts.friends_to_user,
      debts.debts.user_to_friends
    );
    const { 0: singleDebts, ...groupDebts } = debtsByGroup;
    state.userSplitwiseDebts = { singleDebts, groupDebts: Object.values(groupDebts) }
  },
};

export default {
  namespaced: true,
  state: splitwiseDebtsState,
  actions,
  mutations,
};
