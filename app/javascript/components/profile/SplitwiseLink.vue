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
import textField from '../TextField';
import SubmitButton from '../SubmitButton';

export default {
  name: 'SplitwiseOnBoarding',
  components: {
    textField,
    SubmitButton,
  },
  computed: {},
  methods: {
    ...mapActions('user', ['signOut', 'splitwiseUrlConnection']),
    openSplitwiseUrl() {
      this.splitwiseUrlConnection()
        .then(res => {
          window.open(res.authorize_url);
          this.$router.push('/home');
        })
        .catch(err => {
          console.error(err);
        });
    },
  },
};
</script>
