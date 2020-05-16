import { successAlert, errorAlert } from '../../action-types';
import { SUCCESS_ALERT, ERROR_ALERT, CLEAR_ALERT } from '../../mutation-types';

const alertState = {
  type: null,
  message: null,
};

const ALERT_TIMEOUT = 4000;

const actions = {
  [successAlert]({ commit }, message) {
    commit(SUCCESS_ALERT, message);
    setTimeout(() => {
      commit(CLEAR_ALERT);
    }, ALERT_TIMEOUT);
  },
  [errorAlert]({ commit }, message) {
    commit(ERROR_ALERT, message);
    setTimeout(() => {
      commit(CLEAR_ALERT);
    }, ALERT_TIMEOUT);
  },
};

const mutations = {
  [SUCCESS_ALERT](state, message) {
    state.type = 'success';
    state.message = message;
  },
  [ERROR_ALERT](state, message) {
    state.type = 'error';
    state.message = message;
  },
  [CLEAR_ALERT](state) {
    state.type = null;
    state.message = null;
  },
};

export const alertMessage = {
  namespaced: true,
  alertState,
  actions,
  mutations,
};
