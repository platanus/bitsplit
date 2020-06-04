import { getSplitwiseDebts } from '../../action-types';

import {
  GET_SPLIWITSE_DEBTS_ATTEMPT,
  GET_SPLIWITSE_DEBTS_FAIL,
  GET_SPLIWITSE_DEBTS_SUCCESS,
} from '../../mutation-types';

import { getSplitwiseDebtsApi } from '../../../api/user.js';

import { filterSingleDebts, filterGroupDebts } from '../../../helpers';

const splitwiseDebtsState = {
  getSplitwiseDebtsLoading: false,
  userSplitwiseDebts: [],
};

const actions = {
  [getSplitwiseDebts]({ commit, dispatch }, payload) {
    commit(GET_SPLIWITSE_DEBTS_ATTEMPT);

    return getSplitwiseDebtsApi(payload)
      .then(res => {
        commit(
          GET_SPLIWITSE_DEBTS_SUCCESS,
          res.data.data.attributes.user_to_friends,
          res.data.data.attributes.friends_to_user
        );

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
  [GET_SPLIWITSE_DEBTS_SUCCESS](state, user_to_friends, friends_to_user) {
    state.getSplitwiseDebtsLoading = false;
    state.userSplitwiseDebts = {
      user_to_friends: {
        single_user_to_friends: filterSingleDebts(user_to_friends),
        group_user_to_friends: filterGroupDebts(user_to_friends),
      },
      friends_to_user: {
        single_friends_to_user: filterSingleDebts(friends_to_user),
        group_friends_to_user: filterGroupDebts(friends_to_user),
      },
    };
  },
};

export default {
  namespaced: true,
  state: splitwiseDebtsState,
  actions,
  mutations,
};
