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
        commit(GET_SPLIWITSE_DEBTS_SUCCESS, {
          userToFriends: res.data.data.attributes.user_to_friends,
          friendsToUser: res.data.data.attributes.friends_to_user,
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
    state.userSplitwiseDebts = {
      userToFriends: {
        singleUserToFriends: filterSingleDebts(debts.userToFriends),
        groupUserToFriends: filterGroupDebts(debts.userToFriends),
      },
      friendsToUser: {
        singleFriendsToUser: filterSingleDebts(debts.friendsToUser),
        groupFriendsToUser: filterGroupDebts(debts.friendsToUser),
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
