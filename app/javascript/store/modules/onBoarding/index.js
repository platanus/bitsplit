// import { successAlert, errorAlert } from '../../action-types';
// import { SUCCESS_ALERT, ERROR_ALERT, CLEAR_ALERT } from '../../mutation-types';
const currentStepOk = 'currentStepOk';

const CURRENT_OK = 'CURRENT_OK';
const BUDA_OK = 'BUDA_OK';
const SPLITWISE_OK = 'SPLITWISE_OK';
const NEXT_STEP = 'NEXT_STEP';
const PREVIOUS_STEP = 'PREVIOUS_STEP';

const onBoardingState = {
  loading: false, // Para que no se haga doble click
  currentStep: 'buda', // buda - splitwise
  budaDone: false,
  splitwiseDone: false,
};

const getters = {
  onBoardingDone: state => state.budaDone && state.splitwiseDone,
};

const actions = {
  [currentStepOk]({ commit }) {
    commit(CURRENT_OK);
    commit(NEXT_STEP);
  },
};

const mutations = {
  [CURRENT_OK](state) {
    if (state.currentStep === 'buda') {
      state.budaDone = true;
    } else if (state.currentStep === 'splitwise') {
      state.splitwiseDone = true;
    }
  },
  [BUDA_OK](state) {
    state.currentStep = 'splitwise';
    state.budaDone = true;
  },
  [SPLITWISE_OK](state) {
    state.currentStep = null;
    state.splitwiseDone = true;
  },
  [NEXT_STEP](state) {
    state.currentStep = 'splitwise';
  },
  [PREVIOUS_STEP](state) {
    state.currentStep = 'buda';
  },
};

export default {
  namespaced: true,
  state: onBoardingState,
  getters,
  mutations,
  actions,
};
