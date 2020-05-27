// import { successAlert, errorAlert } from '../../action-types';
// import { SUCCESS_ALERT, ERROR_ALERT, CLEAR_ALERT } from '../../mutation-types';
const currentStepOk = 'currentStepOk';

const BUDA_OK = 'BUDA_OK';
const SPLITWISE_OK = 'SPLITWISE_OK';
const NEXT_STEP = 'NEXT_STEP';
const PREVIOUS_STEP = 'PREVIOUS_STEP';

const onBoardingState = {
  loading: false, // Para que no se haga doble click
  currentStep: 'buda', // buda - splitwise
  splitwiseDone: false,
};

const getters = {
  onBoardingDone: state => state.splitwiseDone,
};

const actions = {
  [currentStepOk]({ commit }) {
    commit(NEXT_STEP);
  },
};

const mutations = {
  [BUDA_OK](state) {
    state.currentStep = 'splitwise';
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
