import Vue from 'vue/dist/vue.esm.js';
import Vuex from 'vuex';
import { vuexfireMutations } from 'vuexfire';

import user from './modules/user';
import alertMessage from './modules/alert';
import component from './modules/component';
import notification from './modules/notification';

Vue.use(Vuex);

const store = new Vuex.Store({
  modules: {
    alertMessage,
    user,
    component,
    notification,
  },
  mutations: vuexfireMutations,
});

export default store;
