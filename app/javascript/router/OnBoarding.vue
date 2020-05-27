<template>
  <div>
    <CurrentStep />
    <div class="flex flex-row justify-center fixed-size">
      <StepButton @do-click="PREVIOUS_STEP" :loading="loading">
        <i class="material-icons self-center ml-2">arrow_back_ios</i>
      </StepButton>
      <div class="p-8 w-1/3">
        <budaIndex v-if="currentStep === 'buda'" />
        <SplitwiseOnBoarding v-if="currentStep === 'splitwise'" />
      </div>
      <StepButton @do-click="NEXT_STEP" :loading="loading">
        <i class="material-icons material-icons self-center mr-2"
          >arrow_forward_ios</i
        >
      </StepButton>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from 'vuex';
import BudaIndex from '../components/BudaOnBoarding';
import CurrentStep from '../components/CurrentStep';
import StepButton from '../components/StepButton';
import SplitwiseOnBoarding from '../components/SplitwiseOnBoarding';

export default {
  name: 'OnBoarding',
  data() {
    return {
      routeName: 'OnBoarding',
    };
  },
  components: {
    CurrentStep,
    StepButton,
    BudaIndex,
    SplitwiseOnBoarding,
  },
  methods: {
    ...mapMutations('onBoarding', ['NEXT_STEP', 'PREVIOUS_STEP', 'CURRENT_OK']),
    ...mapActions('onBoarding', ['currentStepOk']),
  },
  computed: {
    ...mapState('onBoarding', ['currentStep', 'loading']),
  },
};
</script>

<style lang="scss">
.fixed-size {
  height: 50vh;
  // width: 30px;
}
</style>
