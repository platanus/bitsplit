<template>
  <div>
    <CurrentStep />
    <div class="flex flex-row justify-center">
      <StepButton @do-click="PREVIOUS_STEP" :loading="loading">
        <i class="material-icons self-center ml-2">arrow_back_ios</i>
      </StepButton>
      <div class="p-8">
        <BudaForm />
        <button
          @click="currentStepOk"
          class="btn w-full ext-black font-bold p-2 rounded focus:outline-none"
          :class="[width === 'full' ? 'w-full' : 'w-normal']"
        >
          Marcar como hecho
        </button>
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
import CurrentStep from '../components/CurrentStep';
import StepButton from '../components/StepButton';
import BudaForm from '../components/BudaForm';

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
    BudaForm,
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

<style lang="scss"></style>
