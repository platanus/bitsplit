<template>
  <div>
    <CurrentStep />
    <div class="max-w-md mx-auto fixed-size flex flex-col justify-between">
      <budaIndex v-if="currentStep === 'buda'" />
      <UserInfoOnboarding v-if="currentStep == 'userInfo'" />
      <SplitwiseOnBoarding v-if="currentStep === 'splitwise'" />
      <div class="flex flex-row justify-between flex-grow-0 py-4">
        <StepButton
          @do-click="PREVIOUS_STEP"
          :forward="false"
          :display="currentStep !== 'buda'"
        >
          <i slot="icon" class="material-icons self-center ml-2"
            >arrow_back_ios</i
          >
          <p slot="text">
            Anterior
          </p>
        </StepButton>
        <StepButton @do-click="NEXT_STEP" :forward="true">
          <i slot="icon" class="material-icons material-icons self-center mr-2"
            >arrow_forward_ios</i
          >
          <p slot="text">
            Saltar
          </p>
        </StepButton>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState, mapMutations, mapActions } from 'vuex';
import BudaIndex from '../components/BudaOnBoarding';
import CurrentStep from '../components/CurrentStep';
import StepButton from '../components/StepButton';
import SplitwiseOnBoarding from '../components/SplitwiseOnBoarding';
import UserInfoOnboarding from '../components/UserInfoOnboarding';

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
    UserInfoOnboarding,
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
}
</style>
