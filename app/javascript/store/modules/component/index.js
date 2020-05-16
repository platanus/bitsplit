import { changeBudaComp, changePaymentComp } from '../../action-types';

import { MUTATE_BUDA_COMPONENT, MUTATE_PAYMENT_COMPONENT } from '../../mutation-types';

const componentState = {
  budaComp: '', // Cambia el componente a renderear en la sección Buda
  paymentComp: '', // Cambia el componente a renderear en la sección pago
};

const actions = {
  [changeBudaComp]({ commit }, payload) {
    commit(MUTATE_BUDA_COMPONENT, payload);
  },
  [changePaymentComp]({ commit }, payload) {
    commit(MUTATE_PAYMENT_COMPONENT, payload);
  },
};

const mutations = {
  [MUTATE_BUDA_COMPONENT](state, payload) {
    state.budaComp = payload;
  },
  [MUTATE_PAYMENT_COMPONENT](state, payload) {
    state.paymentComp = payload;
  },
};

export const component = {
  namespaced: true,
  componentState,
  actions,
  mutations,
};
