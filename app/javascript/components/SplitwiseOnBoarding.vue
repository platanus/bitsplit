<template>
  <div class="flex flex-col justify-between flex-grow">
    <textField class="self-center">
      Haz click en el boton de abajo para linkear tu cuenta de BitSplit a
      <a href="https://www.spliwise.com">Splitwise</a>
    </textField>
    <SubmitButton @do-click="openSplitwiseUrl()">
      Linkear
    </SubmitButton>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import textField from '../components/TextField';
import SubmitButton from '../components/SubmitButton';

export default {
  name: 'SplitwiseOnBoarding',
  components: {
    textField,
    SubmitButton,
  },
  computed: {},
  methods: {
    ...mapActions('user', ['signOut', 'getSplitwiseUrl']),
    ...mapActions('onBoarding', ['currentStepOk']),
    openSplitwiseUrl() {
      this.getSplitwiseUrl()
        .then(res => {
          window.location.href = res.authorize_url;
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
};
</script>
