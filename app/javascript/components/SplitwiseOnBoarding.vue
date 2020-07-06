<template>
  <div
    v-if="!splitwiseSignedIn"
    class="flex flex-col justify-between flex-grow p-12"
  >
    <textField class="self-center">
      Haz click en el boton de abajo para linkear tu cuenta de BitSplit a
      <a href="https://www.spliwise.com" class="text-indigo-500">Splitwise</a>
    </textField>
    <SubmitButton @do-click="openSplitwiseUrl()">
      Linkear
    </SubmitButton>
  </div>
  <div v-else class="flex flex-col justify-between flex-grow p-12">
    <textField class="self-center">
      Ya estás conectado con
      <a href="https://www.spliwise.com" class="text-indigo-500">Splitwise</a>
    </textField>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import textField from '../components/TextField';
import SubmitButton from '../components/SubmitButton';

export default {
  name: 'SplitwiseOnBoarding',
  components: {
    textField,
    SubmitButton,
  },
  computed: {
    ...mapGetters('user', ['splitwiseSignedIn']),
  },
  mounted() {
    console.log(this.splitwiseSignedIn);
  },
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
