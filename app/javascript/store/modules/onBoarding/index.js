import { currentStepOk } from '../../action-types';
import { NEXT_STEP, PREVIOUS_STEP } from '../../mutation-types';
import router from '../../../router';

const onBoardingState = {
  loading: false, // Para que no se haga doble click
  currentStep: 'buda', // buda - splitwise
  splitwiseDone: false,
};

const actions = {
  [currentStepOk]({ commit }) {
    commit(NEXT_STEP);
  },
};

const mutations = {
  [NEXT_STEP](state) {
    if (state.currentStep === 'buda') {
      state.currentStep = 'splitwise';
    } else {
      router.push('/home');
    }
  },
  [PREVIOUS_STEP](state) {
    state.currentStep = 'buda';
  },
};

export default {
  namespaced: true,
  state: onBoardingState,
  mutations,
  actions,
};
