import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';
import { vuexfireMutations } from 'vuexfire';

import user from './modules/user';
import alert from './modules/alert';
import component from './modules/component';
import notification from './modules/notification';
import onBoarding from './modules/onBoarding';
import splitwiseDebts from './modules/splitwiseDebts';

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    alert,
    user,
    component,
    notification,
    onBoarding,
    splitwiseDebts,
  },
  mutations: vuexfireMutations,
});

export default store;
