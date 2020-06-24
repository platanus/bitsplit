import { currentStepOk } from '../../action-types';
import { NEXT_STEP, PREVIOUS_STEP } from '../../mutation-types';
import router from '../../../router';

const onBoardingState = {
  loading: false, // Para que no se haga doble click
  currentStep: 'buda', // buda - splitwise - userInfo
  splitwiseDone: false,
  userInfoDone: false,
};

const actions = {
  [currentStepOk]({ commit }) {
    commit(NEXT_STEP);
  },
};

const mutations = {
  [NEXT_STEP](state) {
    if (state.currentStep === 'userInfo') {
      state.currentStep = 'buda';
      router.push('/home');
    }
    if (state.currentStep === 'splitwise') {
      state.currentStep = 'userInfo';
    }
    if (state.currentStep === 'buda') {
      state.currentStep = 'splitwise';
    }
  },
  [PREVIOUS_STEP](state) {
    if (state.currentStep === 'userInfo') {
      state.currentStep = 'splitwise';
    } else {
      state.currentStep = 'buda';
    }
  },
};

export default {
  namespaced: true,
  state: onBoardingState,
  mutations,
  actions,
};
