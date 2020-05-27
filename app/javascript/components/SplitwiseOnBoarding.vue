<template>
  <div class="h-full flex flex-col justify-around">
    <textField class="">
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
